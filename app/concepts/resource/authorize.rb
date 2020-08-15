# frozen_string_literal: true

module Resource
  class Authorize < Trailblazer::Operation
    step :authorize

    def authorize(ctx, user:, klass:, id:, action:, **)

    end
  end
end