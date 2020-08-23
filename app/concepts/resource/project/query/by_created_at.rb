# frozen_string_literal: true

module Resource
  module Project
    module Query
      class ByCreatedAt < Trailblazer::Operation
        Parameters = Struct.new(:created_at_from, :created_at_to, keyword_init: true)

        step :init
        step Contract::Build(constant: Resource::Project::Query::Contracts::ByCreatedAt)
        step Contract::Validate()
        step :search

        def init(ctx, params:, scope: ::Project.all, **)
          ctx[:model] = Parameters.new(params)
          ctx[:scope] = scope
        end

        def search(ctx, scope:, params:, **)
          ctx[:scope] = search_by_created_at(
            scope,
            params[:created_at_from],
            params[:created_at_to]
          )
        end

        private

        def search_by_created_at(scope, from, to)
          scope = scope.where('created_at >= :from', from: from) if from
          scope = scope.where('created_at <= :to', to: to) if to
          scope
        end
      end
    end
  end
end
