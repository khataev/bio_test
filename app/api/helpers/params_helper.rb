# frozen_string_literal: true

module ParamsHelper
  extend Grape::API::Helpers

  params :client_params do
    requires :name
  end

  params :create_project_params do
    # HINT: client has higher priority over client_id for now
    optional :client, type: Hash do
      use :client_params
    end
    requires :client_id
    requires :name
  end

  params :update_project_params do
    # HINT: client has higher priority over client_id for now
    optional :client, type: Hash do
      use :client_params
    end
    optional :client_id
    optional :name
    optional :status
  end
end
