# frozen_string_literal: true

module ErrorHelper
  extend Grape::API::Helpers

  def not_found(exception)
    error!(
      {
        error: {
          code: code(:not_found),
          message: { "#{exception.model}": 'Не найден' }
        }
      }, code(:not_found)
    )
  end

  def unauthorized
    error!(
      {
        error: {
          code: code(:unauthorized),
          message: 'Unauthorized'
        }
      }, code(:unauthorized)
    )
  end

  def unprocessable_entity_message(*messages)
    error!(
      {
        error: {
          code: code(:unprocessable_entity),
          data: messages
        }
      }, code(:unprocessable_entity)
    )
  end

  def unprocessable_entity_validation_errors(entity)
    unprocessable_entity_message(entity.errors.full_messages)
  end

  private

  def code(status)
    Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
  end
end
