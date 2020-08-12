FactoryBot.define do
  factory :client do
    sequence(:name) { |n| "Name#{n}" }
  end
end
