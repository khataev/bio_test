# frozen_string_literal: true

module Resource
  module Project
    module Query
      module Contracts
        class ByStatuses < Reform::Form
          property :statuses

          validate :correct_statuses

          private

          def correct_statuses
            return unless statuses

            wrong_statuses = statuses.select { |status| ::Project.statuses.keys.exclude?(status) }
            return if wrong_statuses.blank?

            errors.add(:statuses, :wrong, statuses: wrong_statuses)
          end
        end
      end
    end
  end
end