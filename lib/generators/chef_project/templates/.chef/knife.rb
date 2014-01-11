log_level                :info
log_location             STDOUT

node_name                'user'
client_key               'user.pem'
validation_client_name   'chef-validator'
validation_key           '.chef/chef-validator.pem'
chef_server_url          'https://localhost:443'
syntax_check_cache_path  '.chef/syntax_check_cache'
data_bag_path            './data_bags'

knife[:host_key_verify]  = false
knife[:librarian] = false
