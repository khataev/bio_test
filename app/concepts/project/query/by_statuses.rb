# frozen_string_literal: true

module Project::Query
  class ByStatuses < Trailblazer::Operation
    step :init
    step :search

    def init(ctx, scope: Project.all, **)
      ctx[:scope] = scope
    end

    def search(ctx, scope:, statuses: nil, **)
      ctx[:result] = search_by_statuses(scope, statuses)
    end

    private

    def search_by_statuses(scope, statuses)
      return scope if statuses.blank?

      scope.where(status: statuses)
    end
  end
end