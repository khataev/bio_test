# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource::Project::Query::ByClientIds do
  let(:client1) { create :client }
  let(:client2) { create :client }
  let(:client3) { create :client }
  let(:project1) { create :project, client: client1 }
  let(:project2) { create :project, client: client2 }
  let(:project3) { create :project, client: client3 }
  let(:call!) { described_class.call(params: { client_ids: [client1.id, client2.id] }) }

  before do
    project1
    project2
    project3
  end

  it 'filters by client_ids' do
    result = call!
    expect(result).to be_success
    expect(result[:scope].map(&:id)).to eq [project1.id, project2.id]
  end
end
