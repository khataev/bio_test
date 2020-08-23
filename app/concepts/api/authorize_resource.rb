# frozen_string_literal: true

# Returns :authorized_resource when success, otherwise returns failure
# For collections always successful and return filtered elements
module Api
  class AuthorizeResource < Trailblazer::Operation
    pass :authorize
    step :embedded_property?,
         Output(:failure) => Id(:assign_result)
    pass Subprocess(Api::AuthorizeResource),
         input: :authorize_embedded_resource_input,
         output: { authorized_resource: :embedded_property_value }
    step :assign_result

    def authorize(ctx, user:, resource:, action:, **)
      resource_class, resource_ids = resource_params(resource)
      ctx[:authorized_ids] = Clients::Http::AuthorizeResource.new.check_access(
        user_id: user.id,
        action: action,
        resource_class: resource_class,
        resource_ids: resource_ids
      )
    end

    def embedded_property?(_ctx, embedded_property: nil, **)
      embedded_property
    end

    def authorize_embedded_resource_input(_original_ctx, resource:, embedded_property:, **options)
      { resource: resource.send(embedded_property), **options }
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
