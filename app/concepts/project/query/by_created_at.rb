# frozen_string_literal: true

module Project::Query
  class ByCreatedAt < Trailblazer::Operation
    step :init
    step :search

    def init(ctx, scope: Project.all, **)
      ctx[:scope] = scope
    end

    def search(ctx, scope:, created_at_from: nil, created_at_to: nil, **)
      ctx[:result] = search_by_created_at(scope, created_at_from, created_at_to)
    end

    private

    def search_by_created_at(scope, from, to)
      scope = scope.where('created_at >= :from', from: from) if from
      scope = scope.where('created_at <= :to', to: to) if to
      scope
    end
  end
end