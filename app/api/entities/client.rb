# frozen_string_literal: true

module Entities
  class Client < Grape::Entity
    expose :id
    expose :name
    expose :created_at
  end
end
