#!/usr/bin/env ruby

#
# Script Name:: create-workload
# Script Type: API script, using RubySDK and Bracket FOG plugin
# Script Description: Create a workload based on Workload Templates
#
# Script dependancies: 
#
#   Gems:
#     irb-completion
#     fog-brkt
#     optparse
#     yaml 
#
# Copyright 2015, Bracket Computing, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "irb/completion"
require "fog/brkt"
require 'optparse'
require 'yaml'


# First establish a connection to the API portal
##########################################################
compute = Fog::Compute.new({
  :provider => "brkt",
  :brkt_api_host => "https://{url of portal @ brkt.com}/"
})
##########################################################

# Load Option Parser
##########################################################
# The ruby class optparse.OptionParser, is a powerful tool 
# for creating options for this script. For more information
# please visit: http://ruby-doc.org/stdlib-2.2.2/libdoc/optparse/rdoc/OptionParser.html#method-i-make_switch
##########################################################
# add a hash. This hash is where we will store the options
# By default the values are null
options = {:id => nil, :name => nil}

parser = OptionParser.new do|opts|
  opts.banner = "This script takes 2 options, a templateID and a name for the new workload. Usage: create-workload.rb [options]"
  opts.on('-i', '--id TemplateID', 'ID') do |id|
    options[:id] = id;
  end
  opts.on('-n', '--name WorkloadName', 'Name') do |name|
    options[:name] = name;
  end
  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end

parser.parse!

if options[:id] == nil
  print 'Enter Existing Template ID: '
  options[:id] = gets.chomp
end

if options[:name] == nil
  print 'Enter Name for Workload: '
  options[:name] = gets.chomp
end

myID = options[:id]
myName = options[:name]
##########################################################

# Retrieve the default Billing group
##########################################################
default_billing_group = compute.billing_groups.select{|bg| bg.name == "default"}.first 
##########################################################

# Retrieve the Computing Zone
##########################################################
computing_cell = compute.computing_cells.first 
zone = computing_cell.zones.select{|zone| zone.name == "customer"}.first 
##########################################################

# Retrieve workload template based on name used in argument
##########################################################
# First validate that the Template ID entered is a valid one
tmp_id = compute.workload_templates.select{|i| i.id == myID}.first 
if tmp_id == nil
  print "Template ID not found \n"
  exit
end

workload_template = compute.workload_templates.get(myID)
##########################################################

##########################################################
# Deploy Workload based on selected template
# Use the default billing group
##########################################################
# You can create a hash of attribute values that you would like to include
# in the workload deployment. Below is an example. Please feel free to 
# change any of these values
attributes = Hash.new
attributes["name"] = myName
attributes["billing_group"] = default_billing_group.id 
attributes["zone"] = zone.id 
attributes["metadata"] = {"environment" => "dev"}
workload = workload_template.deploy(default_billing_group, attributes)
puts "Creating workload..."
workload.wait_for {ready?}
puts "Workload Deployed"
##########################################################

