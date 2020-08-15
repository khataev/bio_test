# frozen_string_literal: true

class RootApi < Grape::API
  format :json
  helpers ErrorHelper

  # use GrapeLogging::Middleware::RequestLogger, logger: Rails.logger

  rescue_from ActiveRecord::RecordNotFound do |e|
    not_found(e)
  end

  rescue_from Errors::Unauthorized do
    unauthorized
  end

  mount V1::Root
end
