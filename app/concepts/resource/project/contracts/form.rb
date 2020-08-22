# frozen_string_literal: true

module Resource
  module Project
    module Contracts
      class Form < Reform::Form
        property :name
        property :status

        validates :name, :status, presence: true
        # validation do
        #   params do
        #     required(:name).filled(:string)
        #     required(:status).filled(:string)
        #   end
        # end
      end
    end
  end
end