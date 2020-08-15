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
require 'rails_helper'

RSpec.describe Client, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many(:projects).dependent(:destroy) }
end
