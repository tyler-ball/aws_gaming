#
# Cookbook Name:: aws_gaming
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'chef/provisioning/aws_driver'

with_driver "aws:#{ENV['USER']}:us-west-2"

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
    # TODO attribute
    {:port => -1, :protocol => -1, :sources => ["209.210.191.28/32"] }
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

# TODO attributes
user = "tyler_gaming"
password = "Jumper61+"

# lifted from kitchen-ec2
user_data = <<-USER_DATA
<powershell>
$logfile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Logs\\chef-provisioning.log"
#PS Remoting and & winrm.cmd basic config
Enable-PSRemoting -Force -SkipNetworkProfileCheck
& winrm.cmd set winrm/config '@{MaxTimeoutms="1800000"}' >> $logfile
& winrm.cmd set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}' >> $logfile
& winrm.cmd set winrm/config/winrs '@{MaxShellsPerUser="50"}' >> $logfile
#Server settings - support username/password login
& winrm.cmd set winrm/config/service/auth '@{Basic="true"}' >> $logfile
& winrm.cmd set winrm/config/service '@{AllowUnencrypted="true"}' >> $logfile
& winrm.cmd set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}' >> $logfile
#Firewall Config
& netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" profile=public protocol=tcp localport=5985 remoteip=localsubnet new remoteip=any  >> $logfile
"Disabling Complex Passwords" >> $logfile
$seccfg = [IO.Path]::GetTempFileName()
& secedit.exe /export /cfg $seccfg >> $logfile
(Get-Content $seccfg) | Foreach-Object {$_ -replace "PasswordComplexity\\s*=\\s*1", "PasswordComplexity = 0"} | Set-Content $seccfg
& secedit.exe /configure /db $env:windir\\security\\new.sdb /cfg $seccfg /areas SECURITYPOLICY >> $logfile
& cp $seccfg "c:\\"
& del $seccfg
$username="#{user}"
$password="#{password}"
"Creating static user: $username" >> $logfile
& net.exe user /y /add $username $password >> $logfile
"Adding $username to Administrators" >> $logfile
& net.exe localgroup Administrators /add $username >> $logfile
</powershell>
USER_DATA

machine 'windows_gaming_machine' do
  machine_options bootstrap_options: {
    image_id: 'ami-dfefeeef',
    key_name: 'gaming_key',
    security_group_ids: 'gaming_security_group',
    instance_type: 'g2.2xlarge',
    subnet_id: 'gaming_subnet',
    user_data: user_data
  },
  # winrm_password: 'rRmbgYum8g',
  is_windows: true

  action :ready # we don't need to install Chef... yet
end
