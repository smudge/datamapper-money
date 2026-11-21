require "datamapper-money/version"
require 'money'
require 'dm-core'

module DataMapper
  module Money
    def self.included(model)
      model.extend ClassMethods
    end

    module ClassMethods

      def money(name, options = {})
        raise ArgumentError.new('Name must be specified.') if name.empty?

        default                = options.delete(:default)
        property               = DataMapper::Property::Decimal.new(self, name, options)
        name                   = property.name.to_s
        instance_variable_name = property.instance_variable_name
        name_cents             = "#{name}_cents"
        name_currency          = "#{name}_currency"

        options_cents = options.select { |key, _| [:required, :precision, :scale].include?(key) }.merge(:accessor => :private)
        options_cents.merge!(:default => default.cents) if default
        self.property name_cents.to_sym, DataMapper::Property::Decimal, options_cents

        options_currency = options.select { |key, _| key == :required }.merge(:accessor => :private, :length => 3)
        options_currency.merge!(:default => default.currency.to_s) if default
        self.property name_currency.to_sym, DataMapper::Property::String, options_currency

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          #{property.reader_visibility}
          def #{name}
            return #{instance_variable_name} if defined?(#{instance_variable_name})
            return unless #{name_cents} && #{name_currency}
            #{instance_variable_name} = ::Money.new(#{name_cents}, #{name_currency})
          end

          #{property.writer_visibility}
          def #{name}=(value)
            self.#{name_cents}        = value.cents
            self.#{name_currency}     = value.currency
            #{instance_variable_name} = value
          end
        RUBY
      end

    end

    Model.append_inclusions self
  end
end
