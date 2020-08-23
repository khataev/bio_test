# frozen_string_literal: true

module Resource
  module Project
    module Query
      module Contracts
        class ByCreatedAt < Reform::Form
          property :created_at_from
          property :created_at_to

          validate :correct_created_at_from, :correct_created_at_to

          private

          def correct_created_at_from
            DateTime.parse(created_at_from)
          rescue StandardError
            errors.add(:created_at_from, :wrong_datetime, value: created_at_from)
          end

          def correct_created_at_to
            DateTime.parse(created_at_to)
          rescue StandardError
            errors.add(:created_at_to, :wrong_datetime, value: created_at_to)
          end
        end
      end
    end
  end
end