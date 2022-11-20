require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:base_url) { "/api/v1/users" }

  describe 'POST #create' do
    before do
      post base_url, user: { email: 'test@test.com', password: '123456', password_confirmation: '123456' }
    end

    it 'return status created' do
      expect(last_response.status).to eq 201
    end
    
    it 'creates a new user' do
      expect(User.last.email).to eq 'test@test.com'
    end
  end
end