# frozen_string_literal: true

module ParamsHelper
  extend Grape::API::Helpers

  params :client_params do
    requires :name
  end

  params :project_params do
    # HINT: client has higher priority over client_id for now
    optional :client, type: Hash do
      use :client_params
    end
    requires :client_id
    requires :name
  end
end
