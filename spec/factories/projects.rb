FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Name#{n}" }
    status { :new }
    client { nil }
  end
end
