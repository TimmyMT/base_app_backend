require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let!(:base_url) { '/api/v1/sessions' }
  let!(:user) { create(:user, email: 'test@test.com', password: '123456') }

  describe 'POST #create' do
    before do
      post base_url, { user: { email: user.email, password: '123456' } }
    end

    it 'return status created' do
      expect(last_response.status).to eq 201
    end

    it 'return token' do
      decoded_token = JWT.decode json['token'], nil, false
      expect(decoded_token.first['email']).to eq user.email
    end
  end
end