require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/base'

module ATestModule
  class ATestClass
  end
end

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
    assert_kind_of ::Logger, as_3_2? ? @logger.instance_variable_get('@logger') : @logger
    assert_same ::Logger::INFO, @logger.level
    assert_equal 'test', @logger.progname
  end

  def test_logger_should_use_name_as_path
    @logger = @adapter.logger 'test'
    assert File.exist?(File.join(ROOT, 'test.log')), "./test.log should exist"

    @logger = @adapter.logger 'test name'
    assert File.exist?(File.join(ROOT, 'test_name.log')), "./test_name.log should exist"
  end

  def test_logger_should_use_class_name_as_name
    @logger = @adapter.logger self
    assert File.exist?(File.join(ROOT, 'Loggr_Adapter_BaseTest.log')), "./Loggr_Adapter_BaseTest.log should exist"
  end

  def test_should_allow_to_option_to_provide_path
    @logger = @adapter.logger 'test', :to => "other.log"
    assert File.exist?(File.join(ROOT, 'other.log')), "./other.log should exist"
  end

  def test_should_setting_level_via_options
    @logger = @adapter.logger 'test', :level => ::Logger::ERROR
    assert_same ::Logger::ERROR, @logger.level
  end

  def test_normalize_name_converts_all_inputs_to_sane_strings
    assert_equal "logger", @adapter.send(:normalize_name, "logger")
    assert_equal "logger", @adapter.send(:normalize_name, :logger)
    assert_equal "Loggr::Logger", @adapter.send(:normalize_name, "Loggr::Logger")
    assert_equal "Loggr::Adapter", @adapter.send(:normalize_name, Loggr::Adapter)
    assert_equal "Loggr::Adapter::BaseTest", @adapter.send(:normalize_name, self)
    assert_equal "ATestModule", @adapter.send(:normalize_name, ATestModule)
    assert_equal "ATestModule::ATestClass", @adapter.send(:normalize_name, ATestModule::ATestClass)
    assert_equal "ATestModule::ATestClass", @adapter.send(:normalize_name, ATestModule::ATestClass.new)
  end
end