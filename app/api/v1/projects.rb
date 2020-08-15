# frozen_string_literal: true

module V1
  class Projects < Grape::API
    helpers ParamsHelper

    resources :projects do
      desc 'Получить список клиентов'
      params do
        use :search_params
      end
      paginate
      get do
        result = Resource::Project::Query::Search.call(params: declared(params))
        present paginate(result[:scope]), with: Entities::Project
      end

      desc 'Создать проект'
      params do
        use :create_project_params
      end
      post do
        result = Resource::Project::Create.call(
          params: declared(params, include_missing: false)
        )

        if result.success?
          present result[:result], with: Entities::Project
        else
          unprocessable_entity_message(result[:result])
        end
      end

      route_param :project_id, type: String do
        before do
          @project = ::Project.find(params[:project_id])
        end

        desc 'Получить информацию о проекте'
        get do
          present @project, with: Entities::Project, embed: params['embed']
        end

        desc 'Обновить информацию о проекте'
        params do
          use :update_project_params
        end
        patch do
          project_params = declared(params, include_missing: false).except('project_id')
          @project.update!(project_params)
          present @project, with: Entities::Project
        end

        desc 'Удалить проект проект'
        delete do
          @project.destroy!
          status 200
        end
      end
    end
  end
end
