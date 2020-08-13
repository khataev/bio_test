# frozen_string_literal: true

module V1
  class Clients < Grape::API
    helpers ParamsHelper

    resources :clients do
      desc 'Создать клиента'
      params do
        use :client_params
      end
      post do
        client = Client.create declared(params)
        if client.persisted?
          present client, with: Entities::Client
        else
          unprocessable_entity_validation_errors(client)
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
