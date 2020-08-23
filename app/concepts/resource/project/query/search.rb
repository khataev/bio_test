# frozen_string_literal: true

module Resource
  module Project
    module Query
      class Search < Trailblazer::Operation
        step Subprocess(ByClientIds)
        step Subprocess(ByStatuses)
        step Subprocess(ByCreatedAt)
        step Subprocess(ByName)

        fail :failure

        def failure(ctx, **)
          ctx[:errors] = ctx[:'contract.default'].errors.messages[:base]
        end
      end
    end
  end
end
