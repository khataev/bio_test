# frozen_string_literal: true

module OperationResultHelper
  extend Grape::API::Helpers

  def present_result(result, entity, **params)
    if result.success?
      present result[:model], with: entity, **params
    else
      raise Errors::Unauthorized if result[:unauthorized]

      unprocessable_entity_message(result[:errors])
    end
  end

  def present_paginated_result(result, entity)
    if result.success?
      present paginate(result[:scope]), with: entity
    else
      unprocessable_entity_message(result[:errors])
    end
  end
end
