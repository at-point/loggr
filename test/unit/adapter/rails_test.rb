require 'test_helper'
require 'logger'
require 'loggr/lint'
require 'loggr/adapter'
require 'loggr/adapter/rails'

# mock Rails
module MockRails
  def self.logger
    @logger ||= ::Logger.new('/dev/null')
  end
end

class Loggr::Adapter::RailsTest < MiniTest::Unit::TestCase
  def setup
    Object.send(:remove_const, :Rails) if Object.const_defined?(:Rails)
    Object.const_set(:Rails, ::MockRails)
    @adapter = Loggr::Adapter::RailsAdapter.new
  end
  
  include Loggr::Lint::Tests
  
  def test_rails_should_be_a_rails_adapter
    assert_kind_of Loggr::Adapter::RailsAdapter, Loggr::Adapter::Rails
  end
  
  def test_should_use_same_logger_as_rails
    assert_equal ::Rails.logger, Loggr::Adapter::Rails.logger('log')
  end
  
  def test_should_default_to_rails_adapter
    clazz = Class.new do
      extend Loggr::Adapter
    end
    
    assert_equal Loggr::Adapter::Rails, clazz.adapter
  end
end