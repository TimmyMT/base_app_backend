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

  describe 'GET #show' do
    let(:user) { create :user }

    before do
      get "#{base_url}/#{user.id}"
    end

    it 'return status Found' do
      expect(last_response.status).to eq 200
    end

    it 'return expected user info' do
      expect(json['id']).to eq user.id
    end
  end

  describe 'PATCH #update' do
    let(:user) { create :user, first_name: 'john', last_name: 'smith', age: 17 }

    before do
      auth(user)
      patch "#{base_url}/#{user.id}", { profile: { first_name: 'Ben', last_name: 'Howard', age: 25 } }
    end

    it 'return status OK' do
      expect(last_response.status).to eq 200
    end

    it 'return updated info' do
      expect(user.reload.first_name).to eq 'Ben'
    end
  end
end