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

  describe '/api/v1/projects/:project_id' do
    let(:base_url) { "/api/v1/projects/#{project.id}" }
    let(:client) { create :client }
    let(:project) { create :project, client: client }

    describe 'GET /api/v1/projects/:project_id' do
      let(:created_project) { Project.first }

      it 'gets client' do
        get base_url
        expect(last_response.status).to eq 200
        expect(parsed_body).to match expected_body
      end
    end

    describe 'PATCH /api/v1/projects/:project_id' do
      let(:new_client) { create :client }
      let(:new_project_params) do
        project_params = project.as_json
        project_params['client_id'] = new_client.id
        project_params['name'] = 'new project name'
        project_params['status'] = 'closed'
        project_params
      end
      let(:expected_project_params) do
        hash_including(
          client_id: new_client.id,
          name: 'new project name',
          status: 'closed'
        )
      end

      it 'updates project' do
        patch base_url, new_project_params
        expect(last_response.status).to eq 200
        expect(parsed_body).to match expected_project_params
      end
    end

    describe 'DELETE /api/v1/projects/:project_id' do
      it 'deletes project' do
        delete base_url
        expect(last_response.status).to eq 200
        expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST /api/v1/projects' do
    let(:base_url) { '/api/v1/projects' }
    let(:client) { build :client }
    let(:project) { build :project }
    let(:created_client) { Client.first }
    let(:created_project) { Project.first }
    let(:project_with_client) do
      project.as_json.merge(client: client.as_json)
    end

    before do
      client.save!
      project.client_id = client.id
    end

    context 'when success' do
      it 'creates project' do
        post base_url, project.as_json
        expect(last_response.status).to eq 201
        expect(parsed_body).to match expected_body
      end

      it 'creates project and client simultaneously' do
        post base_url, project_with_client
        expect(last_response.status).to eq 201
        expect(parsed_body[:name]).to eq project.name
        expect(created_project.name).to eq project.name
        expect(created_client.name).to eq client.name
      end
    end

    context 'when error' do
      let(:expected_data) { ["Name can't be blank"] }

      it 'return error' do
        project.name = nil
        post base_url, project.as_json
        expect(last_response.status).to eq 422
        expect(parsed_body.dig(:error, :data)).to eq expected_data
      end
    end
  end
end
