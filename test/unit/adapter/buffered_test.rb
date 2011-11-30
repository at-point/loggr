require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/buffered'

class Loggr::Adapter::BufferedTest < MiniTest::Unit::TestCase

  def setup
    @adapter = Loggr::Adapter::BufferedAdapter.new
  end

  def teardown
    unlink_log_files
  end

  include Loggr::Lint::Tests

  def test_buffered_should_be_a_buffered_adapter
    assert_kind_of Loggr::Adapter::BufferedAdapter, Loggr::Adapter::Buffered
  end

  def test_logger_instance_should_be_a_buffered_logger_with_level_debug
    @logger = @adapter.logger 'test'
    assert_kind_of ActiveSupport::BufferedLogger, as_3_2? ? @logger.instance_variable_get('@logger') : @logger
    assert_same ActiveSupport::BufferedLogger::INFO, @logger.level
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
    @logger = @adapter.logger 'test', :level => ActiveSupport::BufferedLogger::ERROR
    assert_same ActiveSupport::BufferedLogger::ERROR, @logger.level
  end
end