# frozen_string_literal: true

module OperationResultHelper
  extend Grape::API::Helpers

  def present_result(result, **params)
    if result.success?
      present result[:model], with: Entities::Project, **params
    else
      unprocessable_entity_message(result[:errors])
    end
  end
end
