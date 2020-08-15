# frozen_string_literal: true

RSpec.shared_context 'when authenticated' do
  let(:user) { create :user }
  let(:token) { token_for_user(user) }

  before do
    set_cookie "jwt=#{token}"
  end
end