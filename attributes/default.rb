require 'open-uri'
default[:my_ip] = open('http://whatismyip.akamai.com').read.strip
default[:aws_driver] = "aws:tester:us-west-2"
