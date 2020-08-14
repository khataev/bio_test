# frozen_string_literal: true

module ParamsHelper
  extend Grape::API::Helpers

  params :raw_client_params do
    requires :name, type: String
  end

  params :raw_project_params do
    optional :client_id, type: String
    requires :name, type: String
    optional :status, type: String
  end

  params :create_client_params do
    use :raw_client_params
    optional :projects, type: Array[JSON] do
      use :raw_project_params
    end
  end

  params :create_project_params do
    # HINT: client has higher priority over client_id for now
    optional :client, type: Hash do
      use :raw_client_params
    end
    use :raw_project_params
  end

  params :update_project_params do
    # HINT: client has higher priority over client_id for now
    optional :client, type: Hash do
      use :raw_client_params
    end
    use :raw_project_params
  end
end
