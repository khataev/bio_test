# frozen_string_literal: true

module Entities
  class Project < Grape::Entity
    # TODO(khataev): без документации?
    expose :id
    expose :client, with: Entities::Client, if: ->(_, options) { options[:embed] == 'client' }
    expose :client_id
    expose :name
    expose :status
    expose :created_at
  end
end
