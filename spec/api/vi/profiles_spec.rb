require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create :access_token }

      it 'returm 200 status' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
        expect(response).to be_success
      end
    end
  end
end
