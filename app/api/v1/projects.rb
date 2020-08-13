# frozen_string_literal: true

module V1
  class Projects < Grape::API
    resources :projects do
      desc 'Создать проект'
      params do
        requires :client_id
        requires :name
      end
      post do
        project = Project.create declared(params)
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
