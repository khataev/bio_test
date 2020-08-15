# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :uuid             not null, primary key
#  name       :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :uuid             not null
#
# Indexes
#
#  index_projects_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project name#{n}" }
    status { :created }
    client { nil }
  end
end
