# frozen_string_literal: true

module V1
  class Projects < Grape::API
    helpers ParamsHelper

    resources :projects do
      desc 'Создать проект'
      params do
        use :project_params
      end
      post do
        # TODO(khataev): to TB operation
        project_params = declared(params, include_missing: false)
        client_params = project_params.delete('client')
        client = client_params ? Client.create(client_params) : nil
        project_params = project_params.merge('client_id' => client.id) if client

        project = Project.create project_params
        if project.persisted?
          present project, with: Entities::Project
        else
          unprocessable_entity_validation_errors(project)
        end
      end

      route_param :project_id, type: String do
        before do
          @project = Project.find(params[:project_id])
        end

        desc 'Получить информацию о проекте'
        get do
          present @project, with: Entities::Project
        end
      end
    end
  end
end
