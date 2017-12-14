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
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returm 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /others' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/profiles/others', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is invalid' do
        get '/api/v1/profiles/others', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create :user }
      let!(:others) { create_list(:user, 2) }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get '/api/v1/profiles/others', params: { format: :json, access_token: access_token.token } }

      it 'returm 200 status' do
        expect(response).to be_success
      end

      it 'no contains current_user' do
        expect(response.body).to be_json_eql(others.to_json)
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(others.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end
end
