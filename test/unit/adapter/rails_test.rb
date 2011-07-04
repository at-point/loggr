require 'test_helper'
require 'loggr/lint'
require 'loggr/adapter/rails'

# mock Rails
module Rails
  def self.logger
    @logger ||= Logger.new('/dev/null')
  end
end

class Loggr::Adapter::RailsTest < MiniTest::Unit::TestCase
  def setup
    @adapter = Loggr::Adapter::RailsAdapter.new
  end
  
  include Loggr::Lint::Tests
  
  def test_rails_should_be_a_rails_adapter
    assert Loggr::Adapter::Rails.is_a?(Loggr::Adapter::RailsAdapter)
  end
  
  def test_should_use_same_logger_as_rails
    assert_equal Loggr::Adapter::Rails.logger('log'), ::Rails.logger
  end
end