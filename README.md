# datamapper-money [![Test](https://github.com/smudge/datamapper-money/actions/workflows/test.yml/badge.svg)](https://github.com/smudge/datamapper-money/actions/workflows/test.yml) [![RubyGems downloads](https://img.shields.io/gem/dt/datamapper-money.svg)](https://rubygems.org/gems/datamapper-money)

Adds a 'money' instance method to DataMapper-based models, for creating properties powered by the 'money' rubygem.

This version uses the `sbf-dm-core` DataMapper fork and Money 7. CI tests Ruby
3.2 through 4.0 with `sbf-dm-sqlite-adapter`. Applications using the original
`dm-core` and `dm-sqlite-adapter` gems must migrate to the corresponding `sbf-`
forks; don't load both implementations in the same application.

## Installation

Add this line to your application's Gemfile:

    gem 'datamapper-money'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install datamapper-money

## Usage

```ruby
require 'datamapper-money'

class Product
  include DataMapper::Resource

  property :id, Serial
  money :price
end

product = Product.new
product.price = Money.new(1234, 'USD')
product.price.cents # => 1234
```

The `money` property stores its value in `price_cents` and `price_currency`
fields. Configure a DataMapper repository before creating or loading models.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See LICENSE.
