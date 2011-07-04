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
    tempfile = Tempfile.new('nop-logger')
    logger = @adapter.logger('nop', :to => tempfile.path)
    logger.error "oops, i failed?"
    logger.close
    tempfile.close
    assert File.read(tempfile.path).length == 0, "Nop logger should not log anything at all, wtf!"
  ensure
    tempfile.unlink  
  end
end