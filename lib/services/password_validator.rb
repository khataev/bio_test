# frozen_string_literal: true

module Services
  class PasswordValidator
    class << self
      def call(*args)
        new(*args).call
      end
    end

    def initialize(user, password)
      @user = user
      @password = password
    end

    def call
      BCrypt::Password.new(@user.encrypted_password) == @password
    end
  end
end