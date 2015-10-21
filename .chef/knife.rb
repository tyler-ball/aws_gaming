current_dir       = ::File.dirname(__FILE__)
parent_dir        = ::File.expand_path(::File.join(current_dir, '..'))
chef_repo_path    current_dir

chef_provisioning machine_max_wait_time: 600
