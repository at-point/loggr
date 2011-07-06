require 'test_helper'
require 'logback_helper'
require 'loggr/slf4j/jars'

class Loggr::SLF4J::JarsTest < MiniTest::Unit::TestCase
  include Loggr::SLF4J
  
  def test_slf4j_api_jar_path
    assert File.exist?(Jars.slf4j_api_jar_path)
    assert_match Jars.slf4j_api_jar_path, %r{/slf4j-api-[0-9\.]+\.jar\z}
  end
  
  def test_logback_core_jar_path
    assert File.exist?(Jars.logback_core_jar_path)
    assert_match Jars.logback_core_jar_path, %r{/logback-core-[0-9\.]+\.jar\z}
  end
  
  def test_logback_jar_path
    assert File.exist?(Jars.logback_jar_path)
    assert_match Jars.logback_jar_path, %r{/logback-classic-[0-9\.]+\.jar\z}    
  end
end