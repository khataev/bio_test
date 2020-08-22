# frozen_string_literal: true

module Api
  class AuthorizeAction < Trailblazer::Operation
    pass :authorize

    def authorize(_ctx, user:, **)
      ::Clients::Http::AuthorizeResource.new.check_action(
        user_id: user.id, resource_class: 'Project', action: 'create'
      )
    end
  end
end
