require 'test_helper'
require 'loggr/adapter/abstract'

class Loggr::Adapter::AbstractTest < Test::Unit::TestCase
  def setup
    @subject = Loggr::Adapter::AbstractAdapter.new
  end
  
  def test_logger_must_be_implemented_and_thus_throws_exception
    assert_raise(RuntimeError) { @subject.logger("logger") }
  end
  
  def test_mdc_uses_a_thread_local_hash_as_store
    
  end
end