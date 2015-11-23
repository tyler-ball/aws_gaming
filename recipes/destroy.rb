require 'chef/provisioning/aws_driver'

with_driver node[:aws_driver]

machine 'windows_gaming_machine' do
  action :destroy
end

aws_subnet 'gaming_subnet' do
  action :destroy
end

aws_security_group 'gaming_security_group' do
  action :destroy
end

aws_vpc 'gaming_vpc' do
  action :destroy
end
