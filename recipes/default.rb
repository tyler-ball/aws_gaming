require 'chef/provisioning/aws_driver'

with_driver node[:aws_driver]

aws_vpc 'gaming_vpc' do
  cidr_block '192.168.0.0/16'
  internet_gateway true
  enable_dns_hostnames true
  main_routes '0.0.0.0/0' => :internet_gateway
end

aws_key_pair 'gaming_key' do
  allow_overwrite true
end

aws_security_group 'gaming_security_group' do
  vpc 'gaming_vpc'
  inbound_rules [
    {:port => -1, :protocol => -1, :sources => ["#{node[:my_ip]}/32"] }
  ]
  outbound_rules [
    {:port => -1, :protocol => -1, :destinations => ["0.0.0.0/0"] }
  ]
end

aws_subnet 'gaming_subnet' do
  vpc 'gaming_vpc'
  cidr_block '192.168.0.0/24'
  map_public_ip_on_launch true
  availability_zone lazy { (driver.ec2_client.describe_availability_zones.availability_zones.map {|r| r.zone_name}).first }
end

AMIS = {
  "us-east-1" => "ami-017dbf6a",
  "us-west-1" => "ami-8735c5c3",
  "us-west-2" => "ami-dfefeeef"
  # There are more than these, I am just lazy :)
}

machine 'windows_gaming_machine' do
  machine_options bootstrap_options: {
    image_id: lazy { AMIS[driver.aws_config.region.to_s.downcase] },
    key_name: 'gaming_key',
    security_group_ids: 'gaming_security_group',
    instance_type: 'g2.2xlarge',
    subnet_id: 'gaming_subnet',
    # The AMI that is published doesn't appear to run user_data so we cannot
    # set it up to log in automatically
    #user_data: node[:user_data]
  },
  winrm_password: 'rRmbgYum8g',
  is_windows: true

  action :ready # we don't need to install Chef... yet
end
