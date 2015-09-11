# StackOps knife.rb file
root_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))

user = ENV['OPSTACK_CHEF_USER']
user_email = ENV['OPSTACK_CHEF_EMAIL']

# Ok, lets build a normal knife file now kk?
log_level                :debug
log_location             STDOUT
node_name                user
chef_server_url          "https://#{ENV['OPSTACK_CHEF_URL']}"
client_key               "#{ENV['OPSTACK_CHEF_PEM']}"
syntax_check_cache_path  "#{root_dir}/.chef/syntax_check_cache"
data_bag_encrypt_version 2
versioned_cookbooks true

cookbook_email           user_email
cookbook_copyright       "OpSitters"
cookbooklicense          "Apache 2.0"

cookbook_path [
                "#{root_dir}/cookbooks", # 3rd Party Books
                "#{root_dir}/rolebooks", # Role Books
                "#{root_dir}/stackbooks" # StackOps Books
              ]
role_path                [ "#{root_dir}/roles" ]
data_bag_path            [ "#{root_dir}/data_bags" ]
environment_path         [ "#{root_dir}/environments" ]

# Knife options
knife[:chef_url] = "https://#{ENV['OPSTACK_CHEF_URL']}"
knife[:concurrency] = 18

# Server Bootstrap Settings
knife[:server_create_timeout] = 3000
knife[:bootstrap_version] = ENV['OPSTACK_CHEF_BOOTSTRAP_VERSION']
knife[:reboot_bootstrap] = false
knife[:template_file] = "#{root_dir}/bootstrap/#{ENV['OPSTACK_CHEF_BOOTSTRAP_TEMPLATE']}"

# Server Backup Settings
knife[:chef_server_backup_dir]= "#{root_dir}/.chef/chef_server_backup"
knife[:chef_cookbook_backup_dir]= "#{root_dir}/.chef/chef_cookbook_backup"

# SSH Settings
knife[:ssh_user] = ENV['OPSTACK_SSH_USERNAME']
knife[:ssh_attribute] = ENV['OPSTACK_SSH_CHEF_ATTRIBUTE']
knife[:ssh_gateway_identity] = ENV['OPSTACK_SSH_PRIVATE_KEY']

# Digitial Ocean creds
knife[:digital_ssh_key_ids] = ENV['OPSTACK_DIGITALOCEAN_SSH_KEY_ID']
knife[:digital_ocean_access_token] = ENV['OPSTACK_DIGITALOCEAN_ACCESS_TOKEN']

# Amazon creds
knife[:ssh_key_name] = ENV['OPSTACK_AWS_SSH_KEY_ID']
knife[:aws_access_key_id] = ENV['OPSTACK_AWS_API_KEY']
knife[:aws_secret_access_key] = ENV['OPSTACK_AWS_API_SECRET']
knife[:region] = ENV['OPSTACK_AWS_REGION']

# Rackspace creds
knife[:rackspace_api_username] = ENV['OPSTACK_RACKSPACE_USER']
knife[:rackspace_api_key] = ENV['OPSTACK_RACKSPACE_KEY']
knife[:rackspace_ssh_keypair] = ENV['OPSTACK_RACKSPACE_SSH_KEY_ID']
knife[:rackspace_region] = ENV['OPSTACK_RACKSPACE_REGION'].to_sym
knife[:rackspace_auth_url] = 'https://identity.api.rackspacecloud.com/v2.0'
knife[:rackspace_version] = 'v2'

puts "\e[32mOpStack\e[0m: Chef URL #{knife[:chef_url]}"