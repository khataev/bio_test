# frozen_string_literal: true

module V1
  class Token < Grape::API
    helpers AuthHelper

    resource :token do
      desc 'Получить токен'
      params do
        requires :email, type: String, desc: 'E-mail пользователя'
        requires :password, type: String, desc: 'Пароль пользователя'
      end
      post '/', authorize: false do
        authenticate

        cookies[:jwt] = {
          value: auth_token.token,
          expires: expiration_time(auth_token.token),
          path: '/',
          httponly: true
        }

        status :created
      end
    end
  end
end
