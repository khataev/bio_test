# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project::Query::ByName do
  let(:client1) { create :client }
  let(:project1) { create :project, client: client1, name: 'QwertY' }
  let(:project2) { create :project, client: client1, name: 'WertyU' }
  let(:project3) { create :project, client: client1, name: 'ErtyuI' }
  let(:call!) { described_class.call(name_cont: 'tyu') }

  before do
    project1
    project2
    project3
  end

  it 'filters by client_ids' do
    result = call!
    expect(result).to be_success
    expect(result[:result].map(&:id)).to eq [project2.id, project3.id]
  end
end
