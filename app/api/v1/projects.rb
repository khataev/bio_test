# frozen_string_literal: true

module V1
  class Projects < Grape::API
    helpers ParamsHelper, OperationResultHelper

    resources :projects do
      desc 'Получить список проектов'
      params do
        use :search_params
      end
      paginate
      get do
        ::Clients::Http::AuthorizeResource.new.check_action(
          user_id: current_user.id, resource_class: 'Project', action: 'index'
        )

        result = Resource::Project::Query::Search.call(params: declared(params))
        present paginate(result[:scope]), with: Entities::Project
      end

      desc 'Создать проект'
      params do
        use :create_project_params
      end
      post do
        result = Api::Project::Create.call(
          params: declared(params, include_missing: false),
          user: current_user
        )
        present_result(result)
      end

      route_param :project_id, type: String do
        before do
          @project = ::Project.find(params[:project_id])
        end

        desc 'Получить информацию о проекте'
        get do
          result = Api::Project::Show.call(
            model: @project,
            user: current_user,
            embedded_property: params['embed']
          )

          present_result(result, embed: params['embed'])
        end

        desc 'Обновить информацию о проекте'
        params do
          use :update_project_params
        end
        patch do
          # TODO(khataev): we could pass id to operation
          result = Api::Project::Update.trace(
            model: @project,
            params: declared(params, include_missing: false),
            user: current_user
          )
          present_result(result)
        end

        desc 'Удалить проект'
        delete do
          # TODO(khataev): we could pass id to operation
          result = Api::Project::Delete.call(
            model: @project,
            user: current_user
          )
          present_result(result)
        end
      end
    end
  end
end
