require 'test_helper'
require 'loggr/adapter/abstract'

class Loggr::Adapter::AbstractTest < Test::Unit::TestCase
  def setup
    @adapter = Loggr::Adapter::AbstractAdapter.new
  end
  
  def test_logger_must_be_implemented_and_thus_throws_exception
    assert_raise(RuntimeError) { @adapter.logger("logger") }
  end
end