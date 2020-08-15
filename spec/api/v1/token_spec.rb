# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Token do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  let(:password) { '1234567890' }
  let(:encrypted_password) do
    BCrypt::Password.create(password)
  end
  let(:user) { create :user, encrypted_password: encrypted_password }
  let(:base_url) { '/api/v1/token' }

  describe 'POST /api/v1/token' do
    context 'with correct credentials' do
      let(:params) do
        {
          email: user.email,
          password: password
        }
      end
      let(:password_validator) { Services::PasswordValidator }

      before do
        post base_url, params
      end

      it 'returns json' do
        expect(last_response.content_type).to eq('application/json')
      end

      it 'returns status created' do
        expect(last_response.status).to eq 201
      end

      it 'sets token in cookies' do
        expect(last_response.cookies.key?('jwt')).to be true
      end
    end

    context 'with incorrect password' do
      let(:params) do
        {
          email: user.email,
          password: '12345'
        }
      end

      before do
        post base_url, params
      end

      it 'returns status created' do
        expect(last_response.status).to eq 401
      end
    end

    context 'with incorrect email' do
      let(:params) do
        {
          email: '11111',
          password: '12345'
        }
      end

      before do
        post base_url, params
      end

      it 'returns status 404' do
        expect(last_response.status).to eq 404
      end
    end
  end
end