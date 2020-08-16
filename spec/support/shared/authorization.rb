# frozen_string_literal: true

# TODO(khataev): remove?
RSpec.shared_context 'with action authorization permitted' do
  # HINT: parameters
  let(:authorized_user) {}
  let(:authorized_resource_class) {}
  let(:authorized_action) {}
  # local variables
  let(:host) { Settings.hosts.authorize_resource }
  let(:check_action_endpoint) { "#{host}/api/v1/check_action" }
  let(:authorized_user_query) do
    {
      user_id: authorized_user.id,
      resource_class: authorized_resource_class,
      action: authorized_action
    }
  end

  before do
    stub_request(:get, check_action_endpoint).with(query: authorized_user_query)
  end
end

# TODO(khataev): remove?
RSpec.shared_context 'with action authorization forbidden' do
  # HINT: parameters
  let(:unauthorized_user) {}
  let(:unauthorized_resource_class) {}
  let(:unauthorized_action) {}
  # local variables
  let(:host) { Settings.hosts.authorize_resource }
  let(:check_action_endpoint) { "#{host}/api/v1/check_action" }
  let(:unauthorized_user_query) do
    {
      user_id: unauthorized_user.id,
      resource_class: unauthorized_resource_class,
      action: unauthorized_action
    }
  end

  before do
    stub_request(:get, check_action_endpoint)
      .with(query: unauthorized_user_query)
      .to_return(status: 401)
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