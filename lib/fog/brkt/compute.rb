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

      request_path "fog/brkt/requests/compute"
      request :create_billing_group
      request :delete_billing_group
      request :list_billing_groups
      request :create_workload
      request :delete_workload
      request :list_workloads
      request :list_zones
      request :list_machine_types

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
            :billing_groups => {},
            :workloads      => {},
            :zones          => {
              "df43995a1d8a48d28b835238bfd079b4" => {
                "customer"             => "ffffffffffff4fffafffffffffffff00",
                "use_main_route_table" => false,
                "network"              => "2ebf551a7de24bfea2280dcdc79ae0df",
                "description"          => "",
                "modified_time"        => "2015-02-23T22:18:59.064137+00:00",
                "requested_state"      => "AVAILABLE",
                "created_by"           => "berndt@brkt.com",
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
