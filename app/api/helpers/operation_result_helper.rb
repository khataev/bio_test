# frozen_string_literal: true

module OperationResultHelper
  extend Grape::API::Helpers

  def present_result(result, entity, **params)
    if result.success?
      present result[:model], with: entity, **params
    else
      unprocessable_entity_message(result[:errors])
    end
  end
end
