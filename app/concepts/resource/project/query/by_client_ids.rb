# frozen_string_literal: true

module Resource
  module Project
    module Query
      class ByClientIds < Trailblazer::Operation
        step :init
        step :search

        def init(ctx, scope: ::Project.all, **)
          ctx[:scope] = scope
        end

        def search(ctx, scope:, params:, **)
          ctx[:scope] = search_by_client_ids(scope, params[:client_ids])
        end

        private

        def search_by_client_ids(scope, client_ids)
          return scope if client_ids.blank?

          scope.where(client_id: client_ids)
        end
      end
    end
  end
end
