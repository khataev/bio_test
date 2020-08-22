# frozen_string_literal: true

module V1
  class Clients < Grape::API
    helpers ParamsHelper, CookiesHelper

    resources :clients do
      desc 'Создать клиента'
      params do
        use :create_client_params
      end
      post do
        result = Resource::Client::Create.call(
          params: declared(params, include_missing: false)
        )

        if result.success?
          present result[:model], with: Entities::Client
        else
          unprocessable_entity_message(result[:'contract.default'].errors.messages)
        end
      end

      route_param :client_id, type: String do
        before do
          @client = ::Client.find(params[:client_id])
        end

        desc 'Получить информацию о клиенте'
        get do
          check_result = Api::AuthorizeResource.call(
            user: current_user,
            resource: @client,
            action: 'show',
            embedded_property: params['embed']
          )
          raise Errors::Unauthorized unless check_result[:authorized_resource]

          present check_result[:authorized_resource], with: Entities::Client, embed: params['embed']
        end
      end
    end
  end
end
