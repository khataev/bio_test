# frozen_string_literal: true

module V1
  class Clients < Grape::API
    helpers ParamsHelper, OperationResultHelper

    resources :clients do
      desc 'Создать клиента'
      params do
        use :create_client_params
      end
      post do
        result = Api::Client::Create.call(
          params: declared(params, include_missing: false),
          user: current_user
        )
        present_result(result, Entities::Client)
      end

      route_param :id, type: String do
        desc 'Получить информацию о клиенте'
        get do
          result = Api::Client::Show.call(
            params: { id: params[:id] },
            user: current_user,
            embedded_property: params['embed']
          )

          present_result(result, Entities::Client, embed: params['embed'])
        end
      end
    end
  end
end
