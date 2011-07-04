require 'rubygems'
require 'minitest/autorun'
require 'tempfile'

# Just to provide some shim ;)
module Loggr
  module SLF4J
  end
  module Adapter
  end
end

class MiniTest::Unit::TestCase
  
  # Path to root
  ROOT = File.dirname(File.dirname(__FILE__))
      
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
  
  # Yields path to tempfile into block, ensures is cleaned up
  # afterwards
  def with_tempfile(name = 'file', &block)
    tempfile = Tempfile.new(name)
    yield(tempfile.path) if block_given?
    tempfile.close
  ensure
    tempfile.unlink
  end
  
  # Ensure all log files are unlinked after block
  def unlink_log_files(&block)
    yield if block_given?
  ensure
    Dir[File.join(File.dirname(File.dirname(__FILE__))), '*.log'].each { |f| File.unlink(f) if f =~ /\.log$/ }
  end  
end
