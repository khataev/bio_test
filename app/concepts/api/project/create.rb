# frozen_string_literal: true

# HINT: requires specs, but they are alike Show/Delete
module Api
  module Project
    class Create < Trailblazer::Operation
      step Subprocess(Api::AuthorizeAction), input: :authorize_input
      fail :authorize_resource_failure, fail_fast: true

      step Subprocess(Resource::Project::Create)
      fail :failure

      def authorize_resource_failure(ctx, **)
        ctx[:unauthorized] = true
      end

      def failure(ctx, **)
        ctx[:errors] = ctx[:'contract.default'].errors.messages
      end

      private

      def authorize_input(_original_ctx, user:, **)
        { user: user, resource_class: 'Project', action: 'create' }
      end
    end
  end
end