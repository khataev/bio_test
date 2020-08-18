# frozen_string_literal: true

module AuthHelper
  extend Grape::API::Helpers

  def expiration_time(token)
    Time.at(JWT.decode(token, nil, false).first['exp']) # rubocop:disable Rails/TimeZone
  end

  def authenticate
    return if Services::PasswordValidator.call(user, params[:password].to_s.strip)

    unauthorized
  end

  def auth_token
    Knock::AuthToken.new(payload: user.to_token_payload)
  end

  def user
    @user ||= User.find_by!(email: params[:email])
  end
end
