# frozen_string_literal: true

module Api
  module Project
    class Create < Trailblazer::Operation
      step Subprocess(Api::AuthorizeAction), input: :authorize_input
      step Subprocess(Resource::Project::Create)
      fail :failure

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