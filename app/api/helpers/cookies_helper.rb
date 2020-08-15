module CookiesHelper
  extend Grape::API::Helpers

  def jwt_token
    env['HTTP_AUTHORIZATION'].to_s.split(' ').last || cookies[:jwt]
  end

  def cookies
    @cookies ||= begin
      request = Grape::Request.new(env)
      cookies = Grape::Cookies.new
      cookies.read(request)
      cookies
    end
  end
end
