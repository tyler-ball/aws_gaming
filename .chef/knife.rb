current_dir       = ::File.expand_path(::File.dirname(__FILE__))

chef_repo_path    current_dir
cookbook_path     = ::File.expand_path(::File.join(current_dir, "cookbooks"))

log_level                :warn
log_location             STDOUT
cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/checksums" )
lockfile                 "#{current_dir}/local-mode-cache/cache/chef-client-running.pid"
file_cache_path          "#{current_dir}/local-mode-cache/cache/"
private_key_write_path   "#{current_dir}/keys/"

chef_provisioning machine_max_wait_time: 600

use_policyfile true

# compatibility mode settings are used because chef-zero doesn't yet support
# native mode:
deployment_group 'aws_gaming-local'
versioned_cookbooks true
policy_document_native_api false
