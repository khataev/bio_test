# frozen_string_literal: true

module Api
  module Project
    class Create < Trailblazer::Operation
      pass :authorize_action
      step Subprocess(Resource::Project::Create)
      fail :failure

      def authorize_action(_ctx, user:, **)
        ::Clients::Http::AuthorizeResource.new.check_action(
          user_id: user.id, resource_class: 'Project', action: 'create'
        )
      end

      def failure(ctx, **)
        ctx[:errors] = ctx[:'contract.default'].errors.messages
      end
    end
  end
end