require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?(object)' do
    let(:current_user) { create(:user) }
    let(:foreign_user) { create(:user) }
    let(:question) { create(:question, user: current_user) }

    it 'owner of question return true' do
      expect(current_user).to be_author_of(question)
    end

    it 'non-owner return false' do
      expect(foreign_user).to_not be_author_of(question)
    end

    it 'owner of nil return false' do
      expect(current_user).to_not be_author_of(nil)
    end
  end

  describe '.from_omniauth' do
    let!(:user) { create(:user) }

    context 'User already has omniauth-authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123') }
      
      it 'return the user' do
        user.authorizations.create(provider: 'facebook', uid: '123')
        expect(User.from_omniauth(auth)).to eq user
      end
    end

    context 'User has not omniauth-authorization' do
      context 'User already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123', info: { email: user.email }) }
        
        it 'does not create new user' do
          expect { User.from_omniauth(auth) }.to_not change(User, :count)
        end

        it 'creates new omniauth-authorization' do
          expect { User.from_omniauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates omniauth-authorization with provider and uid' do
          user = User.from_omniauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.from_omniauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123', info: { email: 'new@mail.com' }) }

        it 'creates new user' do
          expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        end

        it 'return new user' do
          expect(User.from_omniauth(auth)).to be_a(User)
        end

        it 'fills email' do
          user = User.from_omniauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates omniauth-authorization for user' do
          user = User.from_omniauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates omniauth-authorization with provider and uid' do
          authorization = User.from_omniauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.generate' do
    let(:email) { 'genearate@email.com' }

    it 'create and return confirmed user with fresh email' do
      expect(User.generate(email)).to be_a User
    end

    it 'return existing user when email is occupied' do
      create(:user, email: email)
      expect(User.generate(email)).to be_a User
    end
  end
end
