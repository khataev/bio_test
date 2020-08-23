# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Project::Show do
  let(:user) { create :user }
  let(:client) { create :client }
  let(:project) { create :project, client: client }
  let(:call) do
    described_class.call(
      params: { id: project.id },
      user: user,
      embedded_property: embedded_property
    )
  end

  context 'when action is permitted' do
    include_context 'with action authorization turned off'

    context 'without embed' do
      let(:embedded_property) { nil }

      context 'when resource access is permitted' do
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'show' }
            ]
          end
        end

        it 'gets project' do
          result = call
          expect(result).to be_success
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
          result = call
          expect(result).to be_failure
          expect(result[:unauthorized]).to be true
        end
      end
    end

    context 'when embed' do
      let(:embedded_property) { 'client' }

      context 'when embedded resource access is permitted' do
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'show' },
              { user: user, resources: [client], action: 'show' }
            ]
          end
        end

        it 'embeds client' do
          result = call
          expect(result).to be_success
          expect(result[:authorized_resource]).to be_present
          expect(result[:authorized_resource].client).to be_present
        end
      end

      context 'when embedded resource access is forbidden' do
        include_context 'with resource authorization permitted' do
          let(:permitting_params) do
            [
              { user: user, resources: [project], action: 'show' }
            ]
          end
          include_context 'with resource authorization forbidden' do
            let(:forbidding_params) do
              [
                { user: user, resources: [client], action: 'show' }
              ]
            end
          end
        end

        it 'embeds empty client' do
          result = call
          expect(result).to be_success
          expect(result[:authorized_resource]).to be_present
          expect(result[:authorized_resource].client).to be_nil
        end
      end
    end
  end

  context 'when action is forbidden' do
    let(:embedded_property) { nil }

    include_context 'with action authorization forbidden' do
      let(:forbidden_user) { user }
      let(:forbidden_resource_class) { project.class.name }
      let(:forbidden_action) { 'show' }
    end

    it 'returns failure' do
      result = call
      expect(result).to be_failure
      expect(result[:unauthorized]).to be true
    end
  end
end
