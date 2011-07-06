require 'test_helper'
require 'logback_helper'

class Loggr::SLF4J::MdcTest < MiniTest::Unit::TestCase
  def setup
    setup_logback!
    if_jruby do
      require 'loggr/slf4j/mdc'      
      require 'loggr/slf4j/logger'
      @logger = Loggr::SLF4J::Logger.new('test')
      @mdc = Loggr::SLF4J::MDCWrapper.new
    end
  end
  
  def test_should_allow_setting_and_getting_values
    skip_unless_jruby
    @mdc[:key] = "value"
    @mdc["string"] = "string"
    assert_equal "value", @mdc[:key]
    assert_equal "value", @mdc["key"]
    assert_equal "string", @mdc[:string]
    assert_equal "string", @mdc["string"]
  end
  
  def test_clearing_mdc
    skip_unless_jruby
    @mdc[:key] = "value"
    @mdc[:string] = "string"
    assert_equal "value", @mdc[:key]
    assert_equal "string", @mdc[:string]    
    @mdc.clear
    assert_nil @mdc[:key]
    assert_nil @mdc[:string]
  end
  
  def test_delete_from_mdc
    skip_unless_jruby
    @mdc[:key] = "value"
    @mdc[:string] = "string"
    assert_equal "value", @mdc[:key]
    assert_equal "string", @mdc[:string]
    @mdc.delete(:string)
    assert_equal "value", @mdc[:key]
    assert_nil @mdc[:string]
    @mdc.delete(:string)    
  end
  
  def test_to_hash
    skip_unless_jruby
    @mdc[:key] = "value"
    @mdc[:string] = "string"
    hash = @mdc.to_hash
    assert hash.frozen?, "hash should be frozen"
    assert_equal "value", hash["key"]
    assert_equal "string", hash["string"]
    assert_nil hash[:key]
  end
  
  def test_is_written_to_logback_appender
    skip_unless_jruby
    @mdc[:key] = "value"
    @mdc[:string] = "string"
    
    @logger.info "with mdc!"    
    assert_equal({ "key" => "value", "string" => "string" }, @appender.last.getMdc())
    
    @mdc.delete(:string)
    @logger.info "no longer has :string mdc"
    assert_equal({ "key" => "value" }, @appender.last.getMdc())
    
    @mdc.clear
    @logger.info "no mdc anymore"
    
    java_mdc_map = @appender.last.getMdc()
    assert java_mdc_map.nil? || java_mdc_map.empty?, "getMdc() -> Map<String,String> should be nil or empty"
  end
end