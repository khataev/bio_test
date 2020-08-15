# frozen_string_literal: true

module Resource
  module Project
    module Query
      class Search < Trailblazer::Operation
        step :by_client_ids
        step :by_statuses
        step :by_created_at
        step :by_name

        def by_client_ids(ctx, params:, scope: ::Project.all, **)
          ctx[:scope] = ByClientIds.call(scope: scope, **params)[:result]
        end

        def by_statuses(ctx, params:, scope:, **)
          ctx[:scope] = ByStatuses.call(scope: scope, **params)[:result]
        end

        def by_created_at(ctx, params:, scope:, **)
          ctx[:scope] = ByCreatedAt.call(scope: scope, **params)[:result]
        end

        def by_name(ctx, params:, scope:, **)
          ctx[:scope] = ByName.call(scope: scope, **params)[:result]
        end
      end
    end
  end
end
