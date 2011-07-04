require 'test_helper'
require 'loggr/lint'


class Loggr::Adapter::SLF4JTest < MiniTest::Unit::TestCase
  def setup
    java do
      require 'loggr/adapter/slf4j'
      @adapter = Loggr::Adapter::SLF4JAdapter.new
    end
  end

  def test_lint
    skip_unless_java
  end
    
  include(Loggr::Lint::Tests) if java?

  def test_slf4j_should_be_a_slf4j_adapter
    skip_unless_java
    assert Loggr::Adapter::SLF4J.is_a?(Loggr::Adapter::SLF4JAdapter)
  end
end