# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  email              :string           not null
#  encrypted_password :text             not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
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
