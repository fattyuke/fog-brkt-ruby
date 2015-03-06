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
      model      :billing_group
      collection :billing_groups
      model      :server
      collection :servers
      model      :volume
      collection :volumes
      model      :image
      collection :images
      model      :workload
      collection :workloads
      model      :machine_type
      collection :machine_types
      model      :computing_cell
      collection :computing_cells
      model      :network
      model      :network_zone
      collection :network_zones

      request_path "fog/brkt/requests/compute"
      request :create_billing_group
      request :delete_billing_group
      request :list_billing_groups
      request :create_workload
      request :delete_workload
      request :list_workloads
      request :create_network_zone
      request :delete_network_zone
      request :list_network_zones
      request :list_machine_types
      request :create_server
      request :delete_server
      request :list_images
      request :create_volume
      request :create_computing_cell
      request :delete_computing_cell
      request :get_computing_cell
      request :list_computing_cells

      class Real
        API_HOST = "https://portal.demo.berndt.brkt.net"

        def initialize(options={})
          @public_access_token = options[:brkt_public_access_token]
          @private_mac_key     = options[:brkt_private_mac_key]
          @connection          = Fog::XML::Connection.new(API_HOST)
        end

        def request(params)
          params[:method] ||= "GET"

          headers = params[:headers] || {}
          headers["Accept"]        = "application/json"
          headers["Content-type"]  = "application/json"
          headers["Authorization"] = build_auth(URI.join(API_HOST, params[:path]), params[:method])

          response = @connection.request(params.merge(
            :headers => headers
          ))

          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end

          response
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

        def self.data
          @data ||= {
            :computing_cells => {},
            :billing_groups  => {},
            :workloads       => {},
            :servers         => {},
            :volumes         => {},
            :zones           => {
              "df43995a1d8a48d28b835238bfd079b4" => {
                "customer"             => "ffffffffffff4fffafffffffffffff00",
                "use_main_route_table" => false,
                "network"              => "2ebf551a7de24bfea2280dcdc79ae0df",
                "description"          => "",
                "modified_time"        => "2015-02-23T22:18:59.064137+00:00",
                "requested_state"      => "AVAILABLE",
                "created_by"           => "user@example.com",
                "provider_zone"        => {
                  "state" => "IGNORE",
                  "why"   => ""
                },
                "created_time"         => "2015-02-23T22:18:59.064097+00:00",
                "modified_by"          => "user@example.com",
                "cidr_block"           => "10.0.0.0/18",
                "metadata"             => {},
                "id"                   => "df43995a1d8a48d28b835238bfd079b4",
                "name"                 => "customer"
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
                },
                "id"                 => "f789efac46bf43c792e51b73d28fc398",
                "name"               => "Ubuntu 13.10 Saucy (64 bit)"
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
