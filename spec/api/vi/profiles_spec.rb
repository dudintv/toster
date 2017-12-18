require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    def make_request(params = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { make_request access_token: access_token.token }

      it { expect(response).to be_success }

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
    def make_request(params = {})
      get '/api/v1/profiles/others', params: { format: :json }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create :user }
      let!(:others) { create_list(:user, 2) }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { make_request access_token: access_token.token }

      it { expect(response).to be_success }

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
