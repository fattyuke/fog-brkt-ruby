ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

$:.unshift(File.expand_path("../../lib", __FILE__))

require "rspec/core"
require "fog/brkt"

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'mock_helper'))

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

Excon.ssl_verify_peer = false
Fog.timeout = 600 # wait for no longer than 10 minutes

def compute
  return @compute if @compute

  @compute = Fog::Compute.new(provider: 'brkt')
end
compute # touch compute service to load models & requests classes

def customer_id; "ffffffffffff4fffafffffffffffff00"; end

def create_computing_cell
  compute.computing_cells.create(
    :name             => Fog::Brkt::Mock.name,
    :network          => { :cidr_block => "10.0.0.0/16" },
    :provider_options => { :aws_region => "us-west-2" }
  )
end

RSpec.configure do |c|
end
