# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource::Project::Query::ByStatuses do
  let(:client1) { create :client }
  let(:project1) { create :project, client: client1, status: :created }
  let(:project2) { create :project, client: client1, status: :in_progress }
  let(:project3) { create :project, client: client1, status: :closed }
  let(:call!) { described_class.call(statuses: %i[created closed]) }

  before do
    project1
    project2
    project3
  end

  it 'filters by client_ids' do
    result = call!
    expect(result).to be_success
    expect(result[:result].map(&:id)).to eq [project1.id, project3.id]
  end
end
