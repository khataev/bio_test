# frozen_string_literal: true

RSpec.shared_context 'with resource authorization permitted' do
  # HINT: parameters
  let(:permitting_params) { [{ user: nil, resources: [], action: '' }] }
  # local variables
  let(:host) { Settings.hosts.authorize_resource }
  let(:check_access_endpoint) { "#{host}/api/v1/check_access" }
  let(:permitted_requests) do
    permitting_params.map do |params|
      {
        user_id: params[:user].id,
        resource_class: params[:resources].first.class.name,
        resource_ids: params[:resources].map(&:id),
        action: params[:action]
      }
    end
  end
  let(:headers) do
    { 'Content-Type': 'application/json' }
  end

  before do
    permitted_requests.each do |body|
      stub_request(:post, check_access_endpoint)
        .with(body: body, headers: headers)
        .to_return(body: body[:resource_ids].to_json, headers: headers)
    end
  end
end

RSpec.shared_context 'with resource authorization forbidden' do
  # HINT: parameters
  let(:forbidding_params) { [{ user: nil, resources: [], action: '' }] }
  # local variables
  let(:host) { Settings.hosts.authorize_resource }
  let(:check_access_endpoint) { "#{host}/api/v1/check_access" }
  # HINT: names differ, but code is the same only to prevent interference in one example
  let(:forbidden_requests) do
    forbidding_params.map do |params|
      {
        user_id: params[:user].id,
        resource_class: params[:resources].first.class.name,
        resource_ids: params[:resources].map(&:id),
        action: params[:action]
      }
    end
  end
  let(:headers) do
    { 'Content-Type': 'application/json' }
  end

  before do
    forbidden_requests.each do |body|
      stub_request(:post, check_access_endpoint)
        .with(body: body, headers: headers)
        .to_return(body: [].to_json, headers: headers)
    end
  end
end

RSpec.shared_context 'with action authorization turned off' do
  let(:host) { Settings.hosts.authorize_resource }
  let(:check_action_endpoint) { "#{host}/api/v1/check_action" }
  let(:check_access_endpoint) { "#{host}/api/v1/check_access" }

  before do
    # TODO(khataev): find more correct way
    stub_request(:get, check_action_endpoint).with(query: hash_including)
    stub_request(:post, check_access_endpoint).with(body: hash_including)
  end
end