#

# this fields are relevant
log_level                :info
log_location             STDOUT

# this fields are stubs, unless using chef-server this one just filled
# to pass validations
node_name                'user'
client_key               'user.pem'
validation_client_name   'chef-validator'
validation_key           '.chef/chef-validator.pem'
chef_server_url          'https://localhost:443'
syntax_check_cache_path  '.chef/syntax_check_cache'
data_bag_path            './data_bags'

#knife[:ssh_user]        = server['user']
#knife[:ssh_password]    = server['password']
#knife[:hostname]        = server['hostname']
knife[:host_key_verify]  = false
knife[:librarian] = false
