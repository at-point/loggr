require 'test_helper'
require 'loggr/adapter'
require 'loggr/adapter/base'
require 'loggr/factory'

class MockInstanceFactory
  include Loggr::Adapter
end

class Loggr::FactoryTest < MiniTest::Unit::TestCase
  def setup
    Object.send(:remove_const, :Rails) if Object.const_defined?(:Rails)
    @factory = MockInstanceFactory.new
  end

  def test_default_adapter_is_base
    assert_equal @factory.adapter, Loggr::Adapter::Base
  end
end