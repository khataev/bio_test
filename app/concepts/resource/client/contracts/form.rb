# frozen_string_literal: true

module Resource
  module Client
    module Contracts
      class Form < Reform::Form
        property :name

        validates :name, presence: true
        # validation do
        #   params do
        #     required(:name).filled(:string)
        #   end
        # end
      end
    end
  end
end