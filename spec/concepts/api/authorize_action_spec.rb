# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::AuthorizeAction do
  let(:user) { create :user }
  let(:resource_class) { 'Project' }
  let(:action) { 'show' }
  let(:operation_params) do
    { user: user, resource_class: resource_class, action: action }
  end

  context 'when action is permitted' do
    include_context 'with action authorization permitted' do
      let(:permitted_user) { user }
      let(:permitted_resource_class) { resource_class }
      let(:permitted_action) { action }
    end

    it do
      result = described_class.call(operation_params)
      expect(result).to be_success
    end
  end

  context 'when action is forbidden' do
    include_context 'with action authorization forbidden' do
      let(:forbidden_user) { user }
      let(:forbidden_resource_class) { resource_class }
      let(:forbidden_action) { action }
    end

    it do
      # TODO(khataev): change this behaviour
      expect { described_class.call(operation_params) }.to raise_error Errors::Unauthorized
    end
  end
end
