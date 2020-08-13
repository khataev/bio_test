# frozen_string_literal: true

module Entities
  class Client < Grape::Entity
    expose :id
    expose :name
    expose :created_at
    expose :projects, with: Entities::Project, if: ->(_, options) { options[:embed] == 'projects' }
  end
end
