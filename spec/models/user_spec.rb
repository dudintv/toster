require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?(object)' do
    let(:current_user) { create(:user) }
    let(:foreign_user) { create(:user) }
    let(:question) { create(:question, user: current_user) }

    it 'owner of question return true' do
      expect(current_user.author_of?(question)).to eq true
    end

    it 'non-owner return false' do
      expect(foreign_user.author_of?(question)).to eq false
    end

    it 'owner of nil return false' do
      expect(current_user.author_of?(nil)).to eq false
    end
  end
end
