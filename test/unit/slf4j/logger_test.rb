require 'test_helper'
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
end