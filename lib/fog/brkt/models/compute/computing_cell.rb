require "fog/core/model"

module Fog
  module Compute
    class Brkt
      class ComputingCell < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :cidr,        :aliases => :cidr_block
        attribute :provider

        def initialize(options={})
          self.provider ||= "AWS"
          super
        end

        def save
          requires :name, :cidr, :provider

          data = service.create_computing_cell(name, cidr, provider, {
            :aws_region => "us-west-2" # TODO: remove hardcode
          }).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :id

          service.delete_computing_cell(id)
          true
        end
      end
    end
  end
end
