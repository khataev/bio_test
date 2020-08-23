# frozen_string_literal: true

module Api
  module Client
    class Show < Trailblazer::Operation
      step Model(::Client, :find_by)
      step Subprocess(Api::AuthorizeAction), input: :authorize_action_input
      step Subprocess(Api::AuthorizeResource), input: :authorize_resource_input
      fail :authorize_resource_failure

      def authorize_resource_failure(ctx, **)
        ctx[:unauthorized] = true
      end

      private

      def authorize_action_input(_original_ctx, user:, **)
        { user: user, resource_class: 'Client', action: 'show' }
      end

      def authorize_resource_input(_original_ctx, user:, model:, embedded_property:, **)
        { user: user, resource: model, action: 'show', embedded_property: embedded_property }
      end
    end
  end
end