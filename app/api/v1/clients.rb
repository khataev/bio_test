# frozen_string_literal: true

module V1
  class Clients < Grape::API
    helpers ParamsHelper

    resources :clients do
      desc 'Создать клиента'
      params do
        use :create_client_params
      end
      post do
        result = Client::Operations::Create.call(
          params: declared(params, include_missing: false)
        )

        if result.success?
          present result[:result], with: Entities::Client
        else
          unprocessable_entity_message(result[:result])
        end
      end

      route_param :client_id, type: String do
        before do
          @client = Client.find(params[:client_id])
        end

        desc 'Получить информацию о клиенте'
        get do
          present @client, with: Entities::Client, embed: params['embed']
        end
      end
    end
  end
end
