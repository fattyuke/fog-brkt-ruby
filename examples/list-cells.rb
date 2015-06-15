#!/usr/bin/env ruby

#
# Script Name:: list-cells
# Script Type: API script, using RubySDK and Bracket FOG plugin
# Script Description: List all computing cells for account
#
# Script dependancies:
#   
#
# Copyright 2015, Bracket Computing, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "irb/completion"
require "fog/brkt"

# First establish a connection to the API portal
##########################################################
compute = Fog::Compute.new({
    :provider => "brkt",
    :brkt_public_access_token => "93e...",
    :brkt_private_mac_key => "b48...",
    :brkt_api_host => "https://{url of portal @ brkt.com}/"
})
##########################################################

print "List of Cells:\n"
listcell = compute.computing_cells
listcell.each do |cellname|
	puts "#{cellname.name}: #{cellname.id}"
end



