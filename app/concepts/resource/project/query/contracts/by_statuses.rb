# frozen_string_literal: true

module Resource
  module Project
    module Query
      module Contracts
        class ByStatuses < Reform::Form
          validate :correct_statuses

          private

          def correct_statuses
            wrong_statuses = model.select { |status| ::Project.statuses.keys.exclude?(status) }
            return if wrong_statuses.blank?

            errors.add(:base, :wrong_statuses, statuses: wrong_statuses)
          end
        end
      end
    end
  end
end