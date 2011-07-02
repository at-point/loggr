require 'rubygems'
require 'test/unit'

# bad mojo using rescue nil, but it works ;)
begin; require 'redgreen'; rescue LoadError; end

class Test::Unit::TestCase
end
