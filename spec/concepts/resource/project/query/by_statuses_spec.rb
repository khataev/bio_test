# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource::Project::Query::ByStatuses do
  let(:client1) { create :client }
  let(:project1) { create :project, client: client1, status: :created }
  let(:project2) { create :project, client: client1, status: :in_progress }
  let(:project3) { create :project, client: client1, status: :closed }
  let(:call!) { described_class.call(params: { statuses: %w[created closed] }) }
  let(:call_with_wrong_status!) { described_class.call(params: { statuses: %w[createt] }) }

  before do
    project1
    project2
    project3
  end

  it 'filters by client_ids' do
    result = call!
    expect(result).to be_success
    expect(result[:scope].map(&:id)).to eq [project1.id, project3.id]
  end

  it 'validates statuses' do
    result = call_with_wrong_status!
    expect(result).to be_failure
    expect(result[:'contract.default'].errors.messages.key?(:base)).to be true
  end
end
