require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/base'

class Loggr::Adapter::BaseTest < Test::Unit::TestCase
  def setup
    @adapter = Loggr::Adapter::BaseAdapter.new
  end
  
  include Loggr::Lint::Tests
  
  def test_base_should_be_a_base_adapter
    assert Loggr::Adapter::Base.is_a?(Loggr::Adapter::BaseAdapter)
  end
end