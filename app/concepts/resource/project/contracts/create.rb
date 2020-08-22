# frozen_string_literal: true

module Resource
  module Project
    module Contracts
      class Create < Resource::Project::Contracts::Form
        property :client_id
        property :client,
                 form: Resource::Client::Contracts::Form,
                 populate_if_empty: ::Client

        validates :client_id, presence: true, if: -> { client.blank? }
      end
    end
  end
end