# frozen_string_literal: true

# HINT: requires specs, but they are alike Show/Delete
module Api
  module Project
    class Update < Trailblazer::Operation
      step Model(::Project, :find_by)
      step Subprocess(Api::AuthorizeAction), input: :authorize_action_input
      step Subprocess(Api::AuthorizeResource), input: :authorize_resource_input
      fail :authorize_resource_failure, fail_fast: true

      step Subprocess(Resource::Project::Update)
      fail :failure

      def authorize_resource_failure(ctx, **)
        ctx[:unauthorized] = true
      end

      def failure(ctx, **)
        ctx[:errors] = ctx[:'contract.default'].errors.messages
      end

      private

      def authorize_action_input(_original_ctx, user:, **)
        { user: user, resource_class: 'Project', action: 'update' }
      end

      def authorize_resource_input(_original_ctx, user:, model:, **)
        { user: user, resource: model, action: 'update' }
      end
    end
  end
end