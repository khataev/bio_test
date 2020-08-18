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
class Project < ApplicationRecord
  belongs_to :client

  validates :name, presence: true

  enum status: {
    created: 10,
    in_progress: 20,
    closed: 30
  }
end
