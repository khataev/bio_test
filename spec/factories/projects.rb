# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project name#{n}" }
    status { :created }
    client { nil }
  end
end
