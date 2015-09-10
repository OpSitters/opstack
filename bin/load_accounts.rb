#!/usr/bin/env ruby

databag_file = "#{ENV['OPSTACK_DIR']}/environments/#{ENV['OPSTACK_ENV']}/accounts.json"
secret_file = "#{Dir.home}/.opstack/.accounts_key"
prefix = "OPSTACK"

require 'rubygems'
require 'json'
require 'chef/encrypted_data_bag_item'
require 'highline/import'

def export_hash(prefix, hash)
  hash.each do |key, val|
    key_name = "#{prefix}_#{key}".upcase
    if val.is_a?(Hash)
      export_hash(key_name,val)
    else
      print_export(key_name, val)
    end
  end
end

def print_export(var, val)
  puts "export #{var}='#{val}'"
end

data = JSON.parse(File.read(databag_file))
secret = File.read(secret_file)

encrypted_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, secret)
data_bag = Chef::EncryptedDataBagItem.new(encrypted_data, secret)
export_hash(prefix, data_bag.to_hash)