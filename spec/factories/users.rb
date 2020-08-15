# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User name #{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    encrypted_password { '1234567890' }
  end
end
