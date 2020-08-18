# frozen_string_literal: true

module Resource
  module Project
    module Query
      class ByName < Trailblazer::Operation
        step :init
        step :search

        def init(ctx, scope: ::Project.all, **)
          ctx[:scope] = scope
        end

        def search(ctx, scope:, name_cont: nil, **)
          ctx[:result] = search_by_name(scope, name_cont)
        end

        private

        def search_by_name(scope, name_cont)
          return scope if name_cont.blank?

          scope.where('name ILIKE :name_cont', name_cont: "%#{name_cont}%")
        end
      end
    end
  end
end
