module Fog
  module Compute
    class Brkt
      class Real
        def update_volume(id, options={})
          request(
            :expects => [202],
            :method  => "POST",
            :path    => "v1/api/config/brktvolume/#{id}",
            :body    => options
          )
        end
      end

      class Mock
        def update_volume(id, options={})
          raise NotImplementedError
        end
      end
    end
  end
end
