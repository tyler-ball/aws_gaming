# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name "aws_gaming"

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list "aws_gaming::default"
named_run_list "destroy", "aws_gaming::destroy"
named_run_list "stop", "aws_gaming::stop"

# Specify a custom source for a single cookbook:
cookbook "aws_gaming", path: "."
