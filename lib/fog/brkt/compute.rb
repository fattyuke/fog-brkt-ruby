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
            billing_groups: {},
            workloads:      {}
          }
        end

        def data
          self.class.data
        end
      end
    end
  end
end
