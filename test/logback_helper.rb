if RUBY_PLATFORM =~ /java/
  require 'java'
  require 'loggr/slf4j/jars'  
  Loggr::SLF4J.require_jars!
  
  class ArrayAppender
    include Java::ChQosLogbackCore::Appender
    
    attr_reader   :events
    attr_accessor :name
    
    def initialize(name = 'ArrayAppender')
      @mutex = Mutex.new      
      @name = name
      @events = []
    end
    
    alias_method :setName, :name=
    alias_method :getName, :name
    
    def doAppend(event)
      @mutex.synchronize { @events.push(event) }
    end
    
    def stop
    end
    
    def last
      @events.last
    end
  end
end

class MiniTest::Unit::TestCase
  # Configures logback for testing et al.
  def setup_logback!
    if RUBY_PLATFORM =~ /java/
      @appender = ArrayAppender.new
      
      logger_context = Java::OrgSlf4j::LoggerFactory.getILoggerFactory()
      root_logger = logger_context.getLogger(Java::OrgSlf4j::Logger::ROOT_LOGGER_NAME)
      root_logger.detachAndStopAllAppenders()
      root_logger.addAppender(@appender)
      root_logger.setLevel(Java::ChQosLogbackClassic::Level::ALL)
    end
  end
  
  # Verifies log event based on level & message
  def assert_log_event(exp_level, exp_message, event)
    assert_equal exp_level, event.getLevel().toInt()
    assert_equal exp_message, event.getFormattedMessage()
  end
end
