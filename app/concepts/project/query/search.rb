# frozen_string_literal: true

module Project::Query
  class Search < Trailblazer::Operation
    step :by_client_ids
    step :by_statuses
    step :by_created_at
    step :by_name

    def by_client_ids(ctx, params:, scope: Project.all, **)
      ctx[:scope] = Project::Query::ByClientIds.call(scope: scope, **params)[:result]
    end

    def by_statuses(ctx, params:, scope:, **)
      ctx[:scope] = Project::Query::ByStatuses.call(scope: scope, **params)[:result]
    end

    def by_created_at(ctx, params:, scope:, **)
      ctx[:scope] = Project::Query::ByCreatedAt.call(scope: scope, **params)[:result]
    end

    def by_name(ctx, params:, scope:, **)
      ctx[:scope] = Project::Query::ByName.call(scope: scope, **params)[:result]
    end
  end
end