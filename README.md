# aws_gaming

http://lg.io/2015/07/05/revised-and-much-faster-run-your-own-highend-cloud-gaming-service-on-ec2.html

This cookbook sets up a VPC, locked down security group and machine to run streaming
gaming on AWS.

# Instructions

1. Install the [Chef-DK](https://downloads.chef.io/chef-dk/).
2. Checkout this cookbook and navigate to the root directory.
3. The following instructions assume you want to run the cookbook using chef local mode.  If you want to run it on a normal Chef Node, update the cookbook to fit into your workflow accordingly.
4. Create or modify `~/.aws/credentials` and put the credentials you want to use under a profile that matches your username.  Mine looks something like:
```
[tball]
aws_access_key_id=BLAH
aws_secret_access_key=BLAH1
```
5. Run `chef shell-init` and follow its instructions to set the bundled Ruby as the current ruby.
6. Run `chef install && chef export .chef`.
7. Run `chef-client -c ./.chef/knife.rb -z` and wait for the chef run to finish.
8. Log into the instance with Windows Remote Desktop.  The IP address for the machine can be found in the AWS console.  Use the login credentials listed at the bottom of the [instructions](http://lg.io/2015/07/05/revised-and-much-faster-run-your-own-highend-cloud-gaming-service-on-ec2.html) and change the password.  Then follow the rest of the instructions and profit!

# Shutting Down

To destroy the instance when you are done run `chef-client -c ./.chef/knife.rb -z -n destroy`.  This will destroy the machine, security group, subnet and VPC.
