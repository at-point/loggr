# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "loggr/version"

Gem::Specification.new do |s|
  s.name        = "loggr"
  s.version     = Loggr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Logger factory framework (similar to SLF4J)'
  s.description = 'Adapters for different ruby logging backends. Create loggers using different adapters, like Logger (Stdlib), Rails or SLF4J (in JRuby only).'

  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"

  s.authors     = ["Lukas Westermann"]
  s.email       = ["lukas@at-point.ch"]
  s.homepage    = "https://github.com/at-point/loggr/wiki"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'
  
  s.add_development_dependency "minitest", ">= 2.3.0"
  s.add_development_dependency "activesupport", ">= 3.0.0"
end
