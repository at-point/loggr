require 'test_helper'
require 'logback_helper'
require 'loggr/slf4j/jars'

class Loggr::SLF4J::LoggerTest < MiniTest::Unit::TestCase
  def setup
    setup_logback!
    if_jruby do
      require 'loggr/slf4j/logger'
      @logger = Loggr::SLF4J::Logger.new('test')
    end
  end

  def test_behaves_like_stdlib_logger
    skip_unless_jruby
    %w{debug info warn error fatal}.each do |level|
      assert_respond_to @logger, level
      assert_respond_to @logger, "#{level}?"
    end
  end
  
  def test_trace_message
    skip_unless_jruby
    @logger.trace "a trace message"
    assert_log_event 5000, "a trace message", @appender.last
  end
  
  def test_debug_message
    skip_unless_jruby
    @logger.debug "a debug message"
    assert_log_event 10000, "a debug message", @appender.last
  end

  def test_info_message
    skip_unless_jruby
    @logger.info "an info message"
    assert_log_event 20000, "an info message", @appender.last    
  end
  
  def test_warn_message
    skip_unless_jruby
    @logger.warn "a warn message"
    assert_log_event 30000, "a warn message", @appender.last    
  end

  def test_error_message
    skip_unless_jruby
    @logger.error "an error message"
    assert_log_event 40000, "an error message", @appender.last    
  end

  def test_fatal_message
    skip_unless_jruby
    @logger.fatal "a fatal message"
    assert_log_event 40000, "a fatal message", @appender.last    
  end

  def test_logging_message_using_block
    skip_unless_jruby
    @logger.info { "block info message" }
    assert_log_event 20000, "block info message", @appender.last
  end
  
  def test_default_logger_has_no_marker
    skip_unless_jruby
    @logger.info "no marker"
    assert_equal nil, @appender.last.getMarker()
  end
  
  def test_use_progname_as_marker
    skip_unless_jruby
    @logger.info "with marker", "MARK"
    assert_equal "MARK", @appender.last.getMarker().to_s
    
    @logger.debug "other marker", "KRAM"
    assert_equal "KRAM", @appender.last.getMarker().to_s
  end
  
  def test_ability_to_provide_default_marker
    skip_unless_jruby
    @logger = Loggr::SLF4J::Logger.new('test.marker', :marker => "MARK")

    @logger.info "no marker"
    assert_equal "MARK", @appender.last.getMarker().to_s
    
    @logger.debug "other marker", "KRAM"
    assert_equal "KRAM", @appender.last.getMarker().to_s
  end
end