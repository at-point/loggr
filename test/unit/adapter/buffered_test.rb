require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/buffered'

class Loggr::Adapter::BufferedTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Loggr::Adapter::BufferedAdapter.new
  end
  
  include Loggr::Lint::Tests
  
  def test_buffered_should_be_a_buffered_adapter
    assert Loggr::Adapter::Buffered.is_a?(Loggr::Adapter::BufferedAdapter)
  end
end