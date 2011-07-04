require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/base'

class Loggr::Adapter::BaseTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Loggr::Adapter::BaseAdapter.new
  end
  
  def teardown
    unlink_log_files
  end
  
  include Loggr::Lint::Tests
  
  def test_base_should_be_a_base_adapter
    assert Loggr::Adapter::Base.is_a?(Loggr::Adapter::BaseAdapter)
  end
  
  def test_logger_instance_should_be_a_stdlib_logger_with_level_info
    @logger = @adapter.logger 'test'
    assert_kind_of ::Logger, @logger
    assert_same ::Logger::INFO, @logger.level
    assert_equal 'test', @logger.progname
  end
  
  def test_logger_should_use_name_as_path
    @logger = @adapter.logger 'test'
    assert File.exist?(File.join(ROOT, 'test.log')), "./test.log should not exist"
    
    @logger = @adapter.logger 'test name'
    assert File.exist?(File.join(ROOT, 'test_name.log')), "./test_name.log should not exist"
  end
  
  def test_should_allow_to_option_to_provide_path
    @logger = @adapter.logger 'test', :to => "other.log"
    assert File.exist?(File.join(ROOT, 'other.log')), "./other.log should not exist"    
  end
  
  def test_should_setting_level_via_options
    @logger = @adapter.logger 'test', :level => ::Logger::ERROR
    assert_same ::Logger::ERROR, @logger.level
  end  
end