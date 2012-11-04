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

        if default = options.delete(:default)
          unless default.is_a?(Money)
            raise TypeError.new("Expected Money but got #{options[:default].class}")
          end
        end

        property               = DataMapper::Property::Decimal.new(self, name, options)
        name                   = property.name.to_s
        instance_variable_name = property.instance_variable_name
        name_amount            = "#{name}_amount"
        name_currency          = "#{name}_currency"

        options_amount = options.slice(:required, :precision, :scale).merge(:accessor => :private)
        options_amount.merge!(:default => default.amount) if default
        self.property name_amount.to_sym, DataMapper::Property::Decimal, options_amount

        options_currency = options.slice(:required).merge(:accessor => :private, :length => 3)
        options_currency.merge!(:default => default.currency.to_s) if default
        self.property name_currency.to_sym, DataMapper::Property::String, options_currency

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          #{property.reader_visibility}
          def #{name}
            return #{instance_variable_name} if defined?(#{instance_variable_name})
            return unless #{name_amount} && #{name_currency}
            #{instance_variable_name} = Money.new(#{name_amount}, #{name_currency})
          end

          #{property.writer_visibility}
          def #{name}=(value)
            unless value.kind_of?(Money)
              raise TypeError.new("Expected Money but got \#{value.class}")
            end
            self.#{name_amount}       = value.amount
            self.#{name_currency}     = value.currency
            #{instance_variable_name} = value
          end
        RUBY
      end

    end

    Model.append_inclusions self
  end
end
