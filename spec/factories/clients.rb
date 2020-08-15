# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :client do
    sequence(:name) { |n| "Client name#{n}" }
  end
end
