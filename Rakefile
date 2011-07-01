require 'bundler'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

desc 'Test the loggr gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
