# frozen_string_literal: true

module Resource
  module Project
    class Delete < Trailblazer::Operation
      step :destroy!
      fail :failure

      def destroy!(_ctx, model:, **)
        model.destroy
      end

      def failure(ctx, model:, **)
        ctx[:errors] = model.errors.messages
      end
    end
  end
end
