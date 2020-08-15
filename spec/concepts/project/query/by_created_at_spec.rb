# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project::Query::ByCreatedAt do
  let(:client1) { create :client }
  let(:time) { Time.zone.local(2020, 8, 1) }
  let(:project1) { create :project, client: client1, created_at: time }
  let(:project2) { create :project, client: client1, created_at: time + 1.day }
  let(:project3) { create :project, client: client1, created_at: time + 2.days }
  let(:call!) { described_class.call(created_at_from: time + 1, created_at_to: time + 2.days - 1) }

  before do
    project1
    project2
    project3
  end

  it 'filters by client_ids' do
    result = call!
    expect(result).to be_success
    expect(result[:result].map(&:id)).to eq [project2.id]
  end
end
