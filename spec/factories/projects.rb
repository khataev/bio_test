# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Name#{n}" }
    status { :created }
    client { nil }
  end
end
