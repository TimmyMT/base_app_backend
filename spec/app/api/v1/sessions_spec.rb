require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let!(:base_url) { '/api/v1/sessions' }
  let!(:user) { create(:user, email: 'test@test.com', password: '123456') }

  describe 'POST #create' do
    context 'when user exist and params is right' do
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
    
    context 'when user exist and params wrong' do
      before do
        post base_url, { user: { email: user.email, password: '1234567' } }
      end
  
      it 'return status bad request' do
        expect(last_response.status).to eq 400
      end
  
      it 'return error' do
        expect(json['error']).to eq "Something went wrong. Please try again"
      end
    end

    context 'when user exist and params wrong' do
      before do
        post base_url, { user: { email: 'wrong@mail.com', password: '123457' } }
      end
  
      it 'return status bad request' do
        expect(last_response.status).to eq 400
      end
  
      it 'return error' do
        expect(json['error']).to eq "Something went wrong. Please try again"
      end
    end
  end

  describe 'POST #refresh' do
    let(:user) { create :user }
    let(:access_token) { Tokens::Create.new(user).call }
    
    context 'when refresh token is valid' do
      before do
        post "#{base_url}/refresh", { token: access_token.refresh }
      end

      it 'return status created' do
        expect(last_response.status).to eq 201
      end

      it 'return token' do
        decoded_token = JWT.decode json['token'], nil, false
        expect(decoded_token.first['email']).to eq user.email
      end
    end

    context 'when refresh token invalid' do
      before do
        post "#{base_url}/refresh", { token: 'bla-bla-bla_token' }
      end

      it 'return status bad request' do
        expect(last_response.status).to eq 400
      end

      it 'return error' do
        expect(json['error']).to eq "Something went wrong. Please try again"
      end
    end
  end

  describe 'DELETE #logout' do
    context 'when user tries to logout with valid token' do
      let(:user) { create :user }
      
      context 'when access token is valid' do
        before do
          auth(user)
          delete "#{base_url}/logout", {}
        end

        it 'return status no content' do
          expect(last_response.status).to eq 204
        end
      end

      context 'when access token not included' do
        before do
          delete "#{base_url}/logout", {}, { "HTTP_AUTHORIZATION" => "Bearer" }
        end

        it 'return status unauthorized' do
          expect(last_response.status).to eq 401
        end
      end

      context 'when access token invalid' do
        before do
          delete "#{base_url}/logout", {}, { "HTTP_AUTHORIZATION" => "Bearer bla-bla-bla_token" }
        end

        it 'return status unauthorized' do
          expect(last_response.status).to eq 401
        end
      end
    end
  end
end