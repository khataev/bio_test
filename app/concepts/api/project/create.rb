# frozen_string_literal: true

module Api
  module Project
    class Create < Trailblazer::Operation
      step Subprocess(Api::AuthorizeAction)
      step Subprocess(Resource::Project::Create)
      fail :failure

      def failure(ctx, **)
        ctx[:errors] = ctx[:'contract.default'].errors.messages
      end
    end
  end
end