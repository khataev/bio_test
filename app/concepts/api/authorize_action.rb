# frozen_string_literal: true

module Api
  class AuthorizeAction < Trailblazer::Operation
    pass :authorize

    def authorize(_ctx, user:, resource_class:, action:, **)
      ::Clients::Http::AuthorizeResource.new.check_action(
        user_id: user.id, resource_class: resource_class, action: action
      )
    end
  end
end
