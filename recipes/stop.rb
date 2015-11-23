require 'chef/provisioning/aws_driver'

with_driver node[:aws_driver]

machine 'windows_gaming_machine' do
  action :stop
end
