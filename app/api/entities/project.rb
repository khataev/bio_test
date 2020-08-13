# frozen_string_literal: true

module Entities
  class Project < Grape::Entity
    # TODO(khataev): без документации?
    expose :client_id
    expose :name
  end
end
