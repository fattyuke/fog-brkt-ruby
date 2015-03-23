require "base64"
require "openssl"
require "fog/xml"
require "fog/json"

require "fog/brkt/core"

module Fog
  module Compute
    class Brkt < Fog::Service

      requires :brkt_public_access_token, :brkt_private_mac_key

      model_path "fog/brkt/models/compute"
      model      :customer
      model      :billing_group
      collection :billing_groups
      model      :server_template
      collection :server_templates
      model      :server
      collection :servers
      model      :volume_template
      collection :volume_templates
      model      :volume
      collection :volumes
      model      :operating_system
      collection :operating_systems
      model      :image
      collection :images
      model      :csp_image
      collection :csp_images
      model      :workload_template
      collection :workload_templates
      model      :workload
      collection :workloads
      model      :machine_type
      collection :machine_types
      model      :computing_cell
      collection :computing_cells
      model      :network
      collection :networks
      model      :zone
      collection :zones
      model      :security_group
      collection :security_groups
      model      :security_group_rule
      collection :security_group_rules
      model      :load_balancer
      collection :load_balancers
      model      :load_balancer_listener
      collection :load_balancer_listeners

      request_path "fog/brkt/requests/compute"
      request :get_customer
      request :create_billing_group
      request :delete_billing_group
      request :get_billing_group
      request :list_billing_groups
      request :create_workload_template
      request :delete_workload_template
      request :update_workload_template
      request :list_workload_templates
      request :get_workload_template
      request :create_workload
      request :delete_workload
      request :update_workload
      request :get_workload
      request :list_workloads
      request :list_workload_servers
      request :list_networks
      request :get_network
      request :create_zone
      request :delete_zone
      request :list_zones
      request :list_network_zones
      request :list_machine_types
      request :get_server
      request :create_server_template
      request :delete_server_template
      request :update_server_template
      request :get_server_template
      request :list_workload_template_server_templates
      request :create_server
      request :update_server
      request :delete_server
      request :reboot_server
      request :list_servers
      request :list_operating_systems
      request :get_operating_system
      request :create_image
      request :delete_image
      request :list_images
      request :list_os_images
      request :get_image
      request :create_csp_image
      request :delete_csp_image
      request :list_image_csp_images
      request :create_volume_template
      request :delete_volume_template
      request :list_volume_templates
      request :create_volume
      request :delete_volume
      request :update_volume
      request :get_volume
      request :list_volumes
      request :list_instance_volumes
      request :create_volume_snapshot
      request :create_computing_cell
      request :delete_computing_cell
      request :get_computing_cell
      request :list_computing_cells
      request :create_security_group
      request :delete_security_group
      request :get_security_group
      request :list_security_groups
      request :create_security_group_rule
      request :delete_security_group_rule
      request :list_security_group_rules
      request :list_security_group_security_group_rules
      request :create_load_balancer
      request :delete_load_balancer
      request :update_load_balancer
      request :get_load_balancer
      request :list_load_balancers
      request :create_load_balancer_listener
      request :delete_load_balancer_listener
      request :list_load_balancer_listeners

      class Real
        DEFAULT_API_HOST = "http://portal.demo.berndt.brkt.net"

        attr_reader :api_host

        def initialize(options={})
          @public_access_token = options[:brkt_public_access_token]
          @private_mac_key     = options[:brkt_private_mac_key]
          @api_host            = options[:api_host] || DEFAULT_API_HOST
          @connection          = Fog::XML::Connection.new(@api_host)
        end

        def request(params)
          params[:method] ||= "GET"

          headers = params[:headers] || {}
          headers["Accept"]        = "application/json"
          headers["Content-type"]  = "application/json"
          headers["Authorization"] = build_auth(URI.join(api_host, params[:path]), params[:method])

          response = @connection.request(params.merge(
            :headers => headers
          ))

          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end

          response
        end

        def customer
          @customer ||= begin
            Customer.new(get_customer.body)
          end
        end

        private

        def build_auth(uri, method)
          u = URI(uri)
          port = u.port.to_s
          ts = Time.now.to_i.to_s
          nonce = SecureRandom.hex
          full_path = u.path
          full_path += "?" + URI.decode_www_form_component(u.query) if u.query  # params MUST be included for MAC

          message = [ts, nonce, method, full_path, u.host, port].join("\n") + "\n\n"
          hash = OpenSSL::HMAC.digest("sha256", @private_mac_key, message)
          # DO NOT USE encode64() because it add \n at line end
          digestmsg = Base64.strict_encode64(hash)
          "MAC id=\"#{@public_access_token}\", ts=\"#{ts}\", nonce=\"#{nonce}\", mac=\"#{digestmsg}\""
        end
      end

      class Mock
        def initialize(options={})
          @public_access_token = options[:public_access_token]
        end

        def customer
          @customer ||= begin
            Customer.new(get_customer.body)
          end
        end

        def self.data
          @data ||= {
            :customer             => {
              :id   => Fog::Brkt::Mock.id,
              :name => Fog::Brkt::Mock.name
            },
            :computing_cells         => {},
            :billing_groups          => {},
            :workload_templates      => {},
            :workloads               => {},
            :server_templates        => {},
            :servers                 => {},
            :volume_templates        => {},
            :volumes                 => {},
            :networks                => {},
            :security_groups         => {},
            :security_group_rules    => {},
            :load_balancers          => {},
            :load_balancer_listeners => {},
            :zones                => {
              "df43995a1d8a48d28b835238bfd079b4" => {
                "id"                   => "df43995a1d8a48d28b835238bfd079b4",
                "name"                 => "customer",
                "customer"             => "ffffffffffff4fffafffffffffffff00",
                "use_main_route_table" => false,
                "network"              => "2ebf551a7de24bfea2280dcdc79ae0df",
                "description"          => "",
                "modified_time"        => "2015-02-23T22:18:59.064137+00:00",
                "requested_state"      => "AVAILABLE",
                "created_by"           => "user@example.com",
                "created_time"         => "2015-02-23T22:18:59.064097+00:00",
                "modified_by"          => "user@example.com",
                "cidr_block"           => "10.0.0.0/18",
                "metadata"             => {},
                "provider_zone"        => {
                  "state" => "IGNORE",
                  "why"   => ""
                }
              }
            },
            :machine_types   => {
              "565f94793df94bbba3f45ae2745ee23a" => {
                "cpu_cores"            => 4,
                "supports_pv"          => true,
                "provider"             => 1,
                "encrypted_storage_gb" => 36.0,
                "ram"                  => 15.0,
                "id"                   => "565f94793df94bbba3f45ae2745ee23a",
                "hourly_cost"          => "0.49",
                "storage_gb"           => 80
              }
            },
            :images => {
              "f789efac46bf43c792e51b73d28fc398" => {
                "id"                 => "f789efac46bf43c792e51b73d28fc398",
                "name"               => "Ubuntu 13.10 Saucy (64 bit)",
                "customer"           => nil,
                "os_settings"        => {"mounts.options" => "nobootwait"},
                "modified_by"        => nil,
                "description"        => "",
                "unencrypted_parent" => nil,
                "csp_images"         => "/v1/api/config/imagedefinition/f789efac46bf43c792e51b73d28fc398/cspimages",
                "created_by"         => nil,
                "is_encrypted"       => false,
                "metadata"           => {},
                "state"              => "READY",
                "modified_time"      => "2015-02-23T22:03:47.036014+00:00",
                "created_time"       => "2015-02-23T22:03:47.035985+00:00",
                "is_base"            => true,
                "os"                 => {
                  "customer"      => nil,
                  "modified_by"   => nil,
                  "description"   => "",
                  "os_features"   => {},
                  "modified_time" => "2015-02-23T22:03:46.944208+00:00",
                  "label"         => "Ubuntu 13.10 Saucy (64 bit)",
                  "platform"      => "linux",
                  "version"       => "13.10",
                  "created_by"    => nil,
                  "created_time"  => "2015-02-23T22:03:46.944180+00:00",
                  "metadata"      => {},
                  "id"            => "bd2c801afb174ca9baba61363a2a5554",
                  "name"          => "ubuntu"
                }
              },
            },
            :csp_images => {},
            :operating_systems => {
              "60e32d5fe379431392f89fbdcd380da4" => {
                "id" => "60e32d5fe379431392f89fbdcd380da4",
                "customer" => nil,
                "modified_by" => nil,
                "description" => "",
                "os_features" => {},
                "modified_time" => "2015-02-23T22:03:46.991053+00:00",
                "label" => "Bracket Ubuntu 14.04 Trusty (64 bit)",
                "platform" => "linux",
                "version" => "14.04",
                "created_by" => nil,
                "created_time" => "2015-02-23T22:03:46.991024+00:00",
                "metadata" => {},
                "name" => "ubuntu"
              }
            }
          }
        end

        def data
          self.class.data
        end
      end
    end
  end
end
