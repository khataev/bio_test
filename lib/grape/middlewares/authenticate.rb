# frozen_string_literal: true

module Grape
  module Middlewares
    class Authenticate < Grape::Middleware::Base
      include CookiesHelper

      def before
        return if authentication_disabled?

        user = authenticate

        context.send(:instance_variable_set, '@current_user', user)
        context.class.send(:define_method, 'current_user') { instance_variable_get '@current_user' }
      end

      private

      def context
        env['api.endpoint']
      end

      def authentication_disabled?
        opts = context.options[:route_options]
        opts.key?(:authorize) && opts[:authorize] == false
      end

      def authenticate
        auth = Api::User::Authenticate.call(token: jwt_token)
        raise Errors::Unauthorized if auth.failure?

        # TODO(khataev): :user -> :result
        auth[:user]
      end
    end
  end
end