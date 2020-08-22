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

  include_context 'with action authorization turned off'

  describe '/api/v1/projects/:project_id' do
    let(:base_url) { "/api/v1/projects/#{project.id}" }
    let(:client) { create :client }
    let(:project) { create :project, client: client }

    describe 'GET /api/v1/projects/:project_id' do
      let(:created_project) { Project.first }

      context 'when authenticated' do
        include_context 'when authenticated'

        context 'without embed' do
          context 'when resource access is permitted' do
            include_context 'with resource authorization permitted' do
              let(:permitting_params) do
                [
                  { user: user, resources: [project], action: 'show' }
                ]
              end
            end

            it 'gets project' do
              get base_url
              expect(last_response.status).to eq 200
              expect(parsed_body).to match expected_body
            end
          end

          context 'when resource access is forbidden' do
            include_context 'with resource authorization forbidden' do
              let(:forbidding_params) do
                [
                  { user: user, resources: [project], action: 'show' }
                ]
              end
            end

            it 'gets project' do
              get base_url
              expect(last_response.status).to eq 401
            end
          end
        end

        context 'when embed' do
          let(:base_url) { "/api/v1/projects/#{project.id}?embed=client" }
          let(:expected_body) do
            hash_including(
              id: project.id,
              name: project.name,
              client: hash_including(
                id: client.id,
                name: client.name,
                created_at: kind_of(String)
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

          it 'embeds client' do
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

      context 'when authenticated' do
        include_context 'when authenticated'
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'update' }
            ]
          end
        end

        it 'updates project' do
          patch base_url, new_project_params
          expect(last_response.status).to eq 200
          expect(parsed_body).to match expected_project_params
        end
      end

      context 'when unauthenticated' do
        it 'gets 401' do
          patch base_url, new_project_params
          expect(last_response.status).to eq 401
        end
      end
    end

    describe 'DELETE /api/v1/projects/:project_id' do
      context 'when authenticated' do
        include_context 'when authenticated'
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'delete' }
            ]
          end
        end

        it 'deletes project' do
          delete base_url
          expect(last_response.status).to eq 200
          expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when unauthenticated' do
        it 'gets 401' do
          delete base_url
          expect(last_response.status).to eq 401
        end
      end
    end
  end

  describe '/api/v1/projects' do
    let(:base_url) { '/api/v1/projects' }
    let(:client) { create :client }

    describe 'GET /api/v1/projects' do
      context 'when authenticated' do
        include_context 'when authenticated'

        context 'with pagination' do
          before do
            create_list :project, 2, client: client
          end

          it 'returns all projects by default' do
            get base_url
            expect(last_response.status).to eq 200
            expect(parsed_body.count).to eq 2
          end

          it 'returns requested page' do
            get "#{base_url}/?page=1&per_page=1"
            expect(last_response.status).to eq 200
            expect(parsed_body.count).to eq 1
          end
        end

        context 'with filtering' do
          let(:client1) { create :client }
          let(:project1) do
            create :project,
                   client: client,
                   status: :created,
                   created_at: Time.zone.local(2020, 8, 1)
          end
          let(:project2) do
            create :project,
                   client: client1,
                   status: :in_progress,
                   created_at: Time.zone.local(2020, 8, 2)
          end
          let(:project3) do
            create :project,
                   client: client,
                   status: :closed,
                   created_at: Time.zone.local(2020, 8, 3),
                   name: 'qwerty'
          end
          let(:project4) do
            create :project,
                   client: client1,
                   status: :closed,
                   created_at: Time.zone.local(2020, 8, 3),
                   name: 'rtyuiop'
          end
          let(:project5) do
            create :project,
                   client: client1,
                   status: :closed,
                   created_at: Time.zone.local(2020, 8, 4)
          end
          let(:from) { Time.zone.local(2020, 8, 2, 10) }
          let(:to) { from + 1.day }
          let(:query) do
            {
              query: {
                name_cont: 'rty',
                client_ids: [client1.id],
                statuses: %i[in_progress closed],
                created_at_from: from.iso8601,
                created_at_to: to.iso8601
              }
            }
          end
          let(:url) do
            Addressable::Template.new("#{base_url}/{?query*}").expand(query).to_s
          end
          let(:expected_result) do
            [
              hash_including(
                id: project4.id,
                name: project4.name,
                status: project4.status
              )
            ]
          end

          before do
            project1
            project2
            project3
            project4
            project5
          end

          it 'filters by client_id, status, created_at' do
            get url
            expect(last_response.status).to eq 200
            expect(parsed_body).to match expected_result
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

    describe 'POST /api/v1/projects' do
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

      context 'when authenticated' do
        include_context 'when authenticated'

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
          let(:expected_name_error) { { name: ["can't be blank"] } }
          let(:expected_client_id_error) { { client_id: ["can't be blank"] } }

          it 'return error' do
            project.name = nil
            post base_url, project.as_json
            expect(last_response.status).to eq 422
            expect(parsed_body[:errors]).to eq expected_name_error
          end

          it 'returns error if client_id neither client present' do
            project.client_id = nil
            post base_url, project.as_json
            expect(last_response.status).to eq 422
            expect(parsed_body[:errors]).to eq expected_client_id_error
          end
        end
      end

      context 'when unauthenticated' do
        it 'gets 401' do
          post base_url, project.as_json
          expect(last_response.status).to eq 401
        end
      end
    end
  end
end
