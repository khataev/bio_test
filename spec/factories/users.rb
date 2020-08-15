# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User name #{n}" }
  end
end
