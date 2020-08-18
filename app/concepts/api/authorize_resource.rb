# frozen_string_literal: true

module Api
  class AuthorizeResource < Trailblazer::Operation
    pass :authorize
    pass :authorize_embedded
    pass :assign_result

    def authorize(ctx, user:, resource:, action:, **)
      resource_class, resource_ids = resource_params(resource)
      ctx[:authorized_ids] = Clients::Http::AuthorizeResource.new.check_access(
        user_id: user.id,
        action: action,
        resource_class: resource_class,
        resource_ids: resource_ids
      )
    end

    def authorize_embedded(ctx, user:, resource:, action:, **)
      return true unless ctx[:embedded_property]

      result = Api::AuthorizeResource.call(
        user: user, resource: resource.send(ctx[:embedded_property]), action: action, embedded: true
      )
      ctx[:embedded_property_value] = result[:authorized_resource]
    end

    def assign_result(ctx, **)
      ctx[:authorized_resource] = result(**ctx)
    end

    private

    def result(resource:, authorized_ids:, embedded_property: nil, embedded_property_value: nil, **)
      authorized_resource = filter_resource(resource, authorized_ids)
      return authorized_resource unless embedded_property

      Presenters::AuthorizedResource.new(
        authorized_resource,
        embedded_property,
        embedded_property_value
      )
    end

    def filter_resource(resource, authorized_ids)
      filtered_resources = Array.wrap(resource).select { |r| authorized_ids.include?(r.id) }
      relation?(resource) ? filtered_resources : filtered_resources.first
    end

    def resource_params(resource)
      if relation?(resource)
        [resource.first.class.name, resource.ids]
      else
        [resource.class.name, [resource.id]]
      end
    end

    def relation?(resource)
      resource.is_a?(ActiveRecord::Relation)
    end
  end
end
