$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'opstack'))
require 'rspec'
require 'chef/encrypted_data_bag_item'
require 'coveralls'
require 'simplecov'
require 'simplecov-console'

RSpec.configure do |c|
  c.before(:each) do
    Chef::Config.reset
    Chef::Config[:knife] = {}
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console
]
SimpleCov.start