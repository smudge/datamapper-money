require 'minitest/autorun'
require 'dm-sqlite-adapter'
require 'datamapper-money'

DataMapper.setup(:default, 'sqlite::memory:')

class Product
  include DataMapper::Resource

  property :id, Serial
  money :price
end

DataMapper.finalize
DataMapper.repository.adapter.execute(
  'CREATE TABLE products (id INTEGER PRIMARY KEY, price_cents DECIMAL, price_currency VARCHAR(3))'
)

class MoneyTest < Minitest::Test
  def test_assigns_a_money_value
    product = Product.new
    product.price = Money.new(1234, 'USD')

    assert_equal 1234, product.price.cents
    assert_equal 'USD', product.price.currency.to_s
  end

  def test_persists_and_loads_a_money_value
    product = Product.create!(price: Money.new(1234, 'USD'))
    loaded = Product.get(product.id)
    loaded.reload

    assert_equal 1234, loaded.price.cents
    assert_equal 'USD', loaded.price.currency.to_s
  end

  def test_unset_value_is_nil
    assert_nil Product.new.price
  end
end
