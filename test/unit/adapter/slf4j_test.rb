require 'test_helper'
require 'loggr/lint'


class Loggr::Adapter::SLF4JTest < MiniTest::Unit::TestCase
  def setup
    java do
      require 'loggr/adapter/slf4j'
      self.class.send(:include, Loggr::Lint::Tests)
      @adapter = Loggr::Adapter::SLF4JAdapter.new
    end
  end

  def test_slf4j_should_be_a_slf4j_adapter
    skip_unless_java
    assert Loggr::Adapter::SLF4J.is_a?(Loggr::Adapter::SLF4JAdapter)
  end
end