# frozen_string_literal: true

module Resource
  class Authorize < Trailblazer::Operation
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

    def authorize_embedded(ctx, user:, resource:, action:, embed: nil, **)
      return true unless embed

      result = Resource::Authorize.call(
        user: user, resource: resource.send(embed), action: action, embedded: true
      )
      ctx[:embedded_value] = result[:result]
    end

    def assign_result(ctx, **)
      # TODO(khataev): result to authorized_resource?
      ctx[:result] = result(**ctx)
    end

    private

    def result(resource:, authorized_ids:, embed: nil, embedded_value: nil, **)
      authorized_resource = authorized_resource(resource, authorized_ids)
      return authorized_resource unless embed

      Presenters::AuthorizedResource.new(authorized_resource, embed, embedded_value)
    end

    def authorized_resource(resource, authorized_ids)
      authorized_resources = Array.wrap(resource).select { |r| authorized_ids.include?(r.id) }
      relation?(resource) ? authorized_resources : authorized_resources.first
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