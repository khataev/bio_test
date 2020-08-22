# frozen_string_literal: true

module V1
  class Projects < Grape::API
    helpers ParamsHelper

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
        if result.success?
          present result[:model], with: Entities::Project
        else
          unprocessable_entity_message(result[:errors])
        end
      end

      route_param :project_id, type: String do
        before do
          @project = ::Project.find(params[:project_id])
        end

        desc 'Получить информацию о проекте'
        get do
          ::Clients::Http::AuthorizeResource.new.check_action(
            user_id: current_user.id, resource_class: 'Project', action: 'show'
          )
          check_result = Api::AuthorizeResource.call(
            user: current_user,
            resource: @project,
            action: 'show',
            embedded_property: params['embed']
          )
          raise Errors::Unauthorized unless check_result[:authorized_resource]

          present check_result[:authorized_resource], with: Entities::Project, embed: params['embed']
        end

        desc 'Обновить информацию о проекте'
        params do
          use :update_project_params
        end
        patch do
          ::Clients::Http::AuthorizeResource.new.check_action(
            user_id: current_user.id, resource_class: 'Project', action: 'update'
          )

          check_result = Api::AuthorizeResource.call(
            user: current_user,
            resource: @project,
            action: 'update'
          )
          raise Errors::Unauthorized unless check_result[:authorized_resource]

          project_params = declared(params, include_missing: false).except('project_id')
          @project.update!(project_params)
          present @project, with: Entities::Project
        end

        desc 'Удалить проект'
        delete do
          ::Clients::Http::AuthorizeResource.new.check_action(
            user_id: current_user.id, resource_class: 'Project', action: 'show'
          )

          check_result = Api::AuthorizeResource.call(
            user: current_user,
            resource: @project,
            action: 'delete'
          )
          raise Errors::Unauthorized unless check_result[:authorized_resource]

          @project.destroy!
          status 200
        end
      end
    end
  end
end
