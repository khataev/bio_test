# frozen_string_literal: true

Rails.application.routes.draw do
  mount RootApi => '/'

  get '/healthcheck', to: proc { |_env| [200, {}, ['OK']] }
end
