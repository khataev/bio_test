# frozen_string_literal: true

module Resource
  class Authorize < Trailblazer::Operation
    step :authorize
    pass :authorize_embedded
    step :assign_result

    def authorize(_ctx, user:, resource:, action:, **)
      authorized_ids = Clients::Http::AuthorizeResource.new.check_access(
        user_id: user.id,
        action: action,
        resource_class: resource.class.name,
        resource_ids: [resource.id]
      )
      authorized_ids.include?(resource.id)
    rescue StandardError
      false
    end

    def authorize_embedded(ctx, user:, resource:, action:, embed: nil, **)
      return true unless embed

      result = Resource::Authorize.call(
        user: user, resource: resource.send(embed), action: action
      )
      ctx[:embedded_value] = result[:result] if result.success?
    end

    def assign_result(ctx, resource:, embed: nil, embedded_value: nil, **)
      ctx[:result] = result(resource, embed, embedded_value)
    end

    private

    def result(resource, embedded_property, embedded_property_value)
      return resource unless embedded_property

      Presenters::AuthorizedResource.new(resource, embedded_property, embedded_property_value)
    end
  end
end