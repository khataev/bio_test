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
end