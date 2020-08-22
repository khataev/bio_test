# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Clients do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  let(:parsed_body) { JSON.parse(last_response.body, symbolize_names: true) }

  describe 'GET /api/v1/clients/:client_id' do
    let(:base_url) { "/api/v1/clients/#{client.id}" }
    let(:client) { create :client }
    let(:created_client) { Client.first }

    context 'when authenticated' do
      include_context 'when authenticated'

      context 'without embed' do
        context 'when resource access is permitted' do
          include_context 'with resource authorization permitted' do
            let(:permitting_params) do
              [
                { user: user, resources: [client], action: 'show' }
              ]
            end
          end
          it 'gets client' do
            get base_url
            expect(last_response.status).to eq 200
            expect(parsed_body[:name]).to eq client.name
          end
        end

        context 'when resource access is forbidden' do
          include_context 'with resource authorization forbidden' do
            let(:forbidding_params) do
              [
                { user: user, resources: [client], action: 'show' }
              ]
            end
          end
          it 'gets client' do
            get base_url
            expect(last_response.status).to eq 401
          end
        end
      end

      context 'when embed' do
        let(:base_url) { "/api/v1/clients/#{client.id}?embed=projects" }
        let(:project) { create :project, client: client }
        let(:expected_body) do
          hash_including(
            id: client.id,
            name: client.name,
            projects: array_including(
              hash_including(
                id: project.id,
                name: project.name,
                created_at: kind_of(String)
              )
            )
          )
        end

        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'show' },
              { user: user, resources: [client], action: 'show' }
            ]
          end
        end

        it 'embeds projects' do
          get base_url
          expect(last_response.status).to eq 200
          expect(parsed_body).to match expected_body
        end
      end
    end

    context 'when unauthenticated' do
      it 'gets 401' do
        get base_url
        expect(last_response.status).to eq 401
      end
    end
  end

  describe 'POST /api/v1/clients' do
    let(:base_url) { '/api/v1/clients' }
    let(:client) { build :client }
    let(:projects) { build_list :project, 2 }
    let(:created_client) { Client.first }
    let(:client_with_projects) do
      client.as_json.merge(projects: projects.as_json)
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      context 'when success' do
        it 'creates client' do
          post base_url, client.as_json
          expect(last_response.status).to eq 201
          expect(created_client.name).to eq client.name
        end

        it 'creates client and projects simultaneously' do
          post base_url, client_with_projects
          expect(last_response.status).to eq 201
          expect(parsed_body[:name]).to eq client.name
          expect(created_client.name).to eq client.name
          expect(created_client.projects.count).to eq 2
        end
      end

      context 'when error' do
        let(:expected_data) { { name: ["can't be blank"] } }

        it 'return error' do
          client.name = nil
          post base_url, client.as_json
          expect(last_response.status).to eq 422
          expect(parsed_body[:errors]).to eq expected_data
        end
      end
    end

    context 'when unauthenticated' do
      it 'creates client' do
        post base_url, client.as_json
        expect(last_response.status).to eq 401
      end
    end
  end
end
