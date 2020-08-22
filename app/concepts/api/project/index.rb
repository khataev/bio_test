# frozen_string_literal: true

module Api
  module Project
    class Index < Trailblazer::Operation
      # step Model(::Project, :find_by)
      step Subprocess(Api::AuthorizeAction), input: :authorize_action_input
      step Subprocess(Resource::Project::Query::Search)

      private

      def authorize_action_input(_original_ctx, user:, **)
        { user: user, resource_class: 'Project', action: 'index' }
      end
    end
  end
end
