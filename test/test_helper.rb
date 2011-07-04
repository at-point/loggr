require 'rubygems'
require 'minitest/autorun'

module JRubyOnly
  # Returns `true` if running in java/jruby
  def java?; !!(RUBY_PLATFORM =~ /java/) end
  
  # Yield block if java
  def java(warn = nil, &block)
    if java?
      yield if block_given?
    elsif warn
      Kernel.warn warn
    end
  end  
end

extend JRubyOnly

class MiniTest::Unit::TestCase
  extend JRubyOnly
  include JRubyOnly
  
  def skip_unless_java
    skip("requires JRuby") unless java?
  end
end
