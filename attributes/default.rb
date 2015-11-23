require 'open-uri'
default[:my_ip] = open('http://whatismyip.akamai.com').read.strip
default[:aws_driver] = "aws:#{ENV['USER']}:us-west-2"
