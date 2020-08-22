# frozen_string_literal: true

module Api
  module Project
    class Delete < Trailblazer::Operation
      step Model(::Project, :find_by)
      step Subprocess(Api::AuthorizeAction), input: :authorize_action_input
      step Subprocess(Api::AuthorizeResource), input: :authorize_resource_input
      pass :check_authorization_result
      step Subprocess(Resource::Project::Delete)
      fail :failure

      def failure(ctx, **)
        ctx[:errors] = ctx[:'contract.default'].errors.messages
      end

      def check_authorization_result(_ctx, authorized_resource:, **)
        # TODO(khataev): think how to handle this more concise
        raise Errors::Unauthorized unless authorized_resource
      end

      private

      def authorize_action_input(_original_ctx, user:, **)
        { user: user, resource_class: 'Project', action: 'delete' }
      end

      def authorize_resource_input(_original_ctx, user:, model:, **)
        { user: user, resource: model, action: 'delete' }
      end
    end
  end
end