# frozen_string_literal: true

module Api
  module User
    class Authenticate < Trailblazer::Operation
      step :auth

      def auth(ctx, token: nil, **)
        return false unless token

        ctx[:user] = user_from_token(token)
        return false unless ctx[:user]

        true
      end

      private

      def user_from_token(token)
        # TODO(khataev): replace with User
        ::Knock::AuthToken.new(token: token).entity_for(::User)
      rescue ::Knock.not_found_exception_class, JWT::DecodeError => _e
        nil
      end
    end
  end
end