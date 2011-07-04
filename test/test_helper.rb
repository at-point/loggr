require 'rubygems'
require 'minitest/autorun'

# Just to provide some shim ;)
module Loggr
  module SLF4J
  end
  module Adapter
  end
end

class MiniTest::Unit::TestCase
  
  # Returns `true` if running in java/jruby  
  def self.jruby?; !!(RUBY_PLATFORM =~ /java/) end
    
  # Same at instance level
  def jruby?; self.class.jruby? end
  
  # Yield block if java
  def if_jruby(&block)
    yield if block_given? && jruby?
  end  
    
  # Skip tests, unless using jruby
  def skip_unless_jruby
    skip("requires JRuby") unless jruby?
  end
end
