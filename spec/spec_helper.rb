$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'opstack'))
require 'rspec'
require 'coveralls'
require 'simplecov'
require 'simplecov-console'


SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console
]
SimpleCov.start