require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/buffered'

class Loggr::Adapter::BufferedTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Loggr::Adapter::BufferedAdapter.new
  end
  
  include Loggr::Lint::Tests
  
  def test_buffered_should_be_a_buffered_adapter
    assert_kind_of Loggr::Adapter::BufferedAdapter, Loggr::Adapter::Buffered
  end
  
  def test_logger_instance_should_be_a_buffered_logger
    
  end
end