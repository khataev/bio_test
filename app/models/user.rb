# frozen_string_literal: true

class User < ApplicationRecord
  class << self
    def from_token_payload(payload)
      find payload['sub']['id']
    end
  end

  def to_token_payload
    {
      sub: {
        id: id,
        name: name,
        email: email
      }
    }
  end
end
