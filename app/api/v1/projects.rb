# frozen_string_literal: true

module V1
  class Projects < Grape::API
    helpers ParamsHelper, CookiesHelper

    resources :projects do
      desc 'Получить список проектов'
      params do
        use :search_params
      end
      paginate
      get do
        auth = Api::User::Authenticate.call(token: jwt_token)
        raise Errors::Unauthorized if auth.failure?

        result = Resource::Project::Query::Search.call(params: declared(params))
        present paginate(result[:scope]), with: Entities::Project
      end

      desc 'Создать проект'
      params do
        use :create_project_params
      end
      post do
        auth = Api::User::Authenticate.call(token: jwt_token)
        raise Errors::Unauthorized if auth.failure?

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
          auth = Api::User::Authenticate.call(token: jwt_token)
          raise Errors::Unauthorized if auth.failure?

          present @project, with: Entities::Project, embed: params['embed']
        end

        desc 'Обновить информацию о проекте'
        params do
          use :update_project_params
        end
        patch do
          auth = Api::User::Authenticate.call(token: jwt_token)
          raise Errors::Unauthorized if auth.failure?

          project_params = declared(params, include_missing: false).except('project_id')
          @project.update!(project_params)
          present @project, with: Entities::Project
        end

        desc 'Удалить проект'
        delete do
          auth = Api::User::Authenticate.call(token: jwt_token)
          raise Errors::Unauthorized if auth.failure?

          @project.destroy!
          status 200
        end
      end
    end
  end
end
