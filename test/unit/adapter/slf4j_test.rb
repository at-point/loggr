if RUBY_PLATFORM =~ /java/
  require 'test_helper'
  require 'loggr/lint'
  require 'loggr/adapter/slf4j'

  class Loggr::Adapter::SLF4JTest < Test::Unit::TestCase
    def setup
      @adapter = Loggr::Adapter::SLF4JAdapter.new
    end
  
    include Loggr::Lint::Tests
  
    def test_slf4j_should_be_a_slf4j_adapter
      assert Loggr::Adapter::SLF4J.is_a?(Loggr::Adapter::SLF4JAdapter)
    end
  end
end