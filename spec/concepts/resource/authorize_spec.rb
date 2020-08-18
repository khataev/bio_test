# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource::Authorize do
  let(:user) { create :user }
  let(:client) { create :client }
  let(:project) { create :project, client: client }

  context 'with Project' do
    let(:operation_params) do
      { user: user, resource: project, action: 'show' }
    end

    context 'when user has access to project' do
      include_context 'with resource authorization permitted' do
        let(:permitting_params) do
          [
            { user: user, resources: [project], action: 'show' }
          ]
        end
      end

      it 'returns project' do
        result = described_class.call(operation_params)
        expect(result).to be_success
        expect(result[:result].as_json).to eq project.as_json
        expect(result[:result]).to eq project
      end
    end

    context 'when user has no access to project' do
      include_context 'with resource authorization forbidden' do
        let(:forbidding_params) do
          [
            { user: user, resources: [project], action: 'show' }
          ]
        end
      end

      it 'returns project' do
        result = described_class.call(operation_params)
        expect(result).to be_failure
        expect(result[:result]).to be_nil
      end
    end

    context 'with Client embedding' do
      context 'when user has access to project and client' do
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'show' },
              { user: user, resources: [client], action: 'show' }
            ]
          end
        end
        let(:operation_params) do
          { user: user, resource: project, action: 'show', embed: 'client' }
        end

        it 'returns project and client' do
          result = described_class.call(operation_params)
          expect(result).to be_success
          expect(result[:result].id).to eq project.id
          expect(result[:result].client).to be_present
        end
      end

      context 'when user has access to project only' do
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'show' }
            ]
          end
        end
        include_context 'with resource authorization forbidden' do
          let(:forbidding_params) do
            [
              { user: user, resources: [client], action: 'show' }
            ]
          end
        end
        let(:operation_params) do
          { user: user, resource: project, action: 'show', embed: 'client' }
        end

        it 'returns project only' do
          result = described_class.call(operation_params)
          expect(result).to be_success
          expect(result[:result].id).to eq project.id
          expect(result[:result].client).to be_nil
        end
      end
    end
  end

  context 'with Client' do
    # HINT: cases similar to project ones are omitted for brevity
    context 'with Projects embedding' do
      let(:project1) { create :project, client: client }

      context 'when user has access to client and one of its projects' do
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [client], action: 'show' },
              {
                user: user,
                resources: [project, project1],
                forbidden_resources: [project1],
                action: 'show'
              }
            ]
          end
        end

        let(:operation_params) do
          { user: user, resource: client, action: 'show', embed: 'projects' }
        end

        it 'returns client and permitted project' do
          result = described_class.call(operation_params)
          expect(result).to be_success
          expect(result[:result].id).to eq client.id
          expect(result[:result].projects.map(&:id)).to eq [project.id]
        end
      end
    end
  end
end