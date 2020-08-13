# frozen_string_literal: true

module V1
  class Root < Grape::API
    version 'v1', using: :path
    prefix :api
    format :json

    mount V1::Clients
    mount V1::Projects
  end
end
