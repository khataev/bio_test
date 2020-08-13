# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Clients do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  describe 'GET /api/v1/clients/:client_id' do
    let(:base_url) { "/api/v1/clients/#{client.id}" }
    let(:client) { create :client }
    let(:created_client) { Client.first }
    let(:parsed_body) { JSON.parse(last_response.body, symbolize_names: true) }

    it 'gets client' do
      get base_url
      expect(last_response.status).to eq 200
      expect(parsed_body[:name]).to eq client.name
    end
  end

  describe 'POST /api/v1/clients' do
    let(:base_url) { '/api/v1/clients' }
    let(:client) { build :client }
    let(:created_client) { Client.first }

    it 'creates client' do
      post base_url, client.as_json
      expect(last_response.status).to eq 201
      expect(created_client.name).to eq client.name
    end
  end
end
