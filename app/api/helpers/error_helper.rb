# frozen_string_literal: true

module ErrorHelper
  extend Grape::API::Helpers

  def not_found(exception)
    error!(
      {
        errors: [{ "#{exception.model}": 'Не найден' }]
      }, code(:not_found)
    )
  end

  def unauthorized
    error!(
      nil, code(:unauthorized)
    )
  end

  def unprocessable_entity_message(messages)
    error!(
      { errors: messages }, code(:unprocessable_entity)
    )
  end

  private

  def code(status)
    Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
  end
end
