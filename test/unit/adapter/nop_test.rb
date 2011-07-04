require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/nop'

class Loggr::Adapter::NOPTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Loggr::Adapter::NOPAdapter.new
  end
  
  include Loggr::Lint::Tests
  
  def test_nop_should_be_a_nop_adapter
    assert_kind_of Loggr::Adapter::NOPAdapter, Loggr::Adapter::NOP
  end
  
  def test_nop_should_not_write_any_files
    with_tempfile do |file|
      logger = @adapter.logger('nop', :to => file)
      logger.error "oops, i failed?"
      logger.close
      assert File.read(file).length == 0, "Nop logger should not log anything at all, wtf!"
    end
  end
end