require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter'
require 'loggr/adapter/base'
require 'loggr/factory'

class MockInstanceFactory
  include Loggr::Adapter
end

module Mocks
  class MyAdapter < Loggr::Adapter::BaseAdapter; end
end

class Loggr::FactoryTest < MiniTest::Unit::TestCase
  def setup
    Object.send(:remove_const, :Rails) if Object.const_defined?(:Rails)
    @factory = MockInstanceFactory.new
    @adapter = LoggerFactory # lint it!
    @adapter.adapter = Loggr::Adapter::Base
  end
    
  def teardown
    unlink_log_files
  end  

  def test_default_adapter_is_base
    assert_equal @factory.adapter, Loggr::Adapter::Base
  end
  
  def test_change_adapter_using_symbol
    @factory.adapter = :buffered
    assert_equal @factory.adapter, Loggr::Adapter::Buffered
  end
  
  def test_change_adapter_to_slf4j_using_symbol
    skip_unless_jruby    
    @factory.adapter = :slf4j
    assert_equal @factory.adapter, Loggr::Adapter::SLF4J    
  end
  
  def test_change_adapter_using_string
    @factory.adapter = 'NOP'
    assert_equal @factory.adapter, Loggr::Adapter::NOP    
  end
  
  def test_change_adapter_to_nop
    @factory.adapter = :nop
    assert_equal @factory.adapter, Loggr::Adapter::NOP
  end

  def test_change_adapter_to_nop_by_using_nil
    @factory.adapter = nil
    assert_equal @factory.adapter, Loggr::Adapter::NOP
  end

  def test_change_adapter_to_nop_by_using_false
    @factory.adapter = false
    assert_equal @factory.adapter, Loggr::Adapter::NOP
  end
    
  def test_change_adapter_to_instance
    @factory.adapter = Mocks::MyAdapter.new
    assert_kind_of Mocks::MyAdapter, @factory.adapter
  end
  
  # Lint LoggerFactory, should work the same as an adapter
  include Loggr::Lint::Tests
  
  # Ensure class
  def test_logger_factory
    singleton_class = (class << LoggerFactory; self end)
    assert singleton_class.included_modules.include?(Loggr::Adapter), "LoggerFactory should extend Loggr::Adapter"
  end
end