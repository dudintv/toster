require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'Facebook' do
    let(:auth) { OmniAuth.config.mock_auth[:facebook] }
    let(:user) { create(:user, email: auth.info.email) }
    
    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    context 'with a new facebook user' do
      before do
        get :facebook
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
      it 'sign in user' do
        expect(controller.current_user).to eq User.first
      end
    end

    context 'with existing and confirmed facebook user' do
      before do
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid, confirmed_at: Time.zone.now)
        get :facebook
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end
      it 'sign in user' do
        expect(controller.current_user).to eq user
      end
    end

    context 'with existing but unconfirmed facebook user' do
      before do
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :facebook
      end

      it 'render authorization/unconfirmed' do
        expect(response).to render_template 'authorization/unconfirmed'
      end
      it 'not sign in user' do
        expect(controller.current_user).to be_nil
      end
    end
  end
end
