# frozen_string_literal: true

module Resource
  module Project
    module Contracts
      class Update < Resource::Project::Contracts::Form
        property :client_id

        validates :client_id, presence: true
      end
    end
  end
end