# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Projects do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  let(:expected_body) do
    hash_including(
      client_id: client.id,
      name: project.name
    )
  end
  let(:parsed_body) { JSON.parse(last_response.body, symbolize_names: true) }

  describe 'GET /api/v1/projects/:project_id' do
    let(:base_url) { "/api/v1/projects/#{project.id}" }
    let(:client) { create :client }
    let(:project) { create :project, client: client }
    let(:created_project) { Project.first }

    it 'gets client' do
      get base_url
      expect(last_response.status).to eq 200
      expect(parsed_body).to match expected_body
    end
  end

  describe 'POST /api/v1/projects' do
    let(:base_url) { '/api/v1/projects' }
    let(:client) { build :client }
    let(:project) { build :project }
    let(:created_client) { Client.first }
    let(:created_project) { Project.first }

    it 'creates project' do
      client.save!
      project.client_id = client.id
      post base_url, project.as_json
      expect(last_response.status).to eq 201
      expect(parsed_body).to match expected_body
    end
  end
end
