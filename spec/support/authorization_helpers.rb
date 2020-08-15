# frozen_string_literal: true

module Specs
  module AuthorizationHelpers
    def token_for_user(user)
      token_for_user_payload(user.to_token_payload)
    end

    private

    def token_for_user_payload(payload)
      JWT.encode(payload, secret_key, token_signature_algorithm)
    end

    def token_signature_algorithm
      'HS256'
    end

    def secret_key
      Settings.knock.token_secret_signature_key
    end
  end
end