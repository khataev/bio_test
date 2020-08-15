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
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User name #{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    encrypted_password { '1234567890' }
  end
end
