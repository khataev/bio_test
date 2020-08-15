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
require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :client }
end
