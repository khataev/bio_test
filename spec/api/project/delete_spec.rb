# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Project::Delete do
  let(:user) { create :user }
  let(:client) { create :client }
  let(:project) { create :project, client: client }
  let(:call) do
    described_class.call(
      params: { id: project.id },
      user: user
    )
  end

  context 'when action is permitted' do
    let(:embedded_property) { nil }

    include_context 'with action authorization turned off'

    context 'when resource access is permitted' do
      include_context 'with resource authorization permitted' do
        let(:permitting_params) do
          [
            { user: user, resources: [project], action: 'delete' }
          ]
        end
      end

      it 'destroys project' do
        result = call
        expect(result).to be_success
        expect { project.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when resource access is forbidden' do
      include_context 'with resource authorization forbidden' do
        let(:forbidding_params) do
          [
            { user: user, resources: [project], action: 'delete' }
          ]
        end
      end

      it 'fails to destroy project' do
        result = call
        project.reload

        expect(result).to be_failure
        expect(result[:unauthorized]).to be true
        expect(project).to be_present
      end
    end
  end

  context 'when action is forbidden' do
    let(:embedded_property) { nil }

    include_context 'with action authorization forbidden' do
      let(:forbidden_user) { user }
      let(:forbidden_resource_class) { project.class.name }
      let(:forbidden_action) { 'delete' }
    end

    it 'returns failure' do
      result = call
      project.reload

      expect(result).to be_failure
      expect(result[:unauthorized]).to be true
      expect(project).to be_present
    end
  end
end
