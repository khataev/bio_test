# frozen_string_literal: true

module ParamsHelper
  extend Grape::API::Helpers

  params :client_params do
    requires :name, type: String
  end

  params :project_params do
    optional :client_id, type: String
    requires :name, type: String
    optional :status, type: String
  end

  params :create_client_params do
    use :client_params
    optional :projects, type: Array[JSON] do
      use :project_params
    end
  end

  params :create_project_params do
    # HINT: client has higher priority over client_id
    optional :client, type: Hash do
      use :client_params
    end
    use :project_params
  end

  params :update_project_params do
    # HINT: client has higher priority over client_id
    optional :client, type: Hash do
      use :client_params
    end
    use :project_params
  end

  params :search_params do
    optional :name_cont, type: String, desc: 'Substring to search in name'
    optional :client_ids, type: Array, coerce_with: JSON, desc: 'Filter by client ids'
    optional :statuses, type: Array, coerce_with: JSON, desc: 'Filter by project status'
    optional :created_at_from, type: String, desc: 'Created at left boundary'
    optional :created_at_to, type: String, desc: 'Created at right boundary'
  end
end
