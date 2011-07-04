require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter'

class Loggr::Adapter::SLF4JTest < MiniTest::Unit::TestCase
  def setup
    setup_logback!    
    if_jruby do
      require 'loggr/adapter/slf4j'
      @adapter = Loggr::Adapter::SLF4JAdapter.new
    end
  end

  def test_lint
    skip_unless_jruby
  end
    
  include(Loggr::Lint::Tests) if jruby?

  def test_slf4j_should_be_a_slf4j_adapter
    skip_unless_jruby
    assert Loggr::Adapter::SLF4J.is_a?(Loggr::Adapter::SLF4JAdapter)
  end
end