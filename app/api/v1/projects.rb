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
        result = Api::Project::Index.call(
          params: declared(params),
          user: current_user
        )
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
        present_result(result, Entities::Project)
      end

      route_param :id, type: String do
        desc 'Получить информацию о проекте'
        get do
          result = Api::Project::Show.call(
            params: { id: params[:id] },
            user: current_user,
            embedded_property: params['embed']
          )

          present_result(result, Entities::Project, embed: params['embed'])
        end

        desc 'Обновить информацию о проекте'
        params do
          use :update_project_params
        end
        patch do
          result = Api::Project::Update.trace(
            params: declared(params, include_missing: false),
            user: current_user
          )
          present_result(result, Entities::Project)
        end

        desc 'Удалить проект'
        delete do
          result = Api::Project::Delete.call(
            params: { id: params[:id] },
            user: current_user
          )
          present_result(result, Entities::Project)
        end
      end
    end
  end
end
