# frozen_string_literal: true

module Resource
  module Project
    module Query
      class ByStatuses < Trailblazer::Operation
        PARAMETERS = %i[statuses].freeze
        ModelObject = Struct.new(*PARAMETERS, keyword_init: true)

        step :init
        step Contract::Build(constant: Resource::Project::Query::Contracts::ByStatuses)
        step Contract::Validate()
        step :search

        def init(ctx, params:, scope: ::Project.all, **)
          ctx[:model] = ModelObject.new(params.slice(*PARAMETERS))
          ctx[:scope] = scope
        end

        def search(ctx, scope:, params:, **)
          ctx[:scope] = search_by_statuses(scope, params[:statuses])
        end

        private

        def search_by_statuses(scope, statuses)
          return scope if statuses.blank?

          scope.where(status: statuses)
        end
      end
    end
  end
end
