require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }

  describe '#after_create' do
    let(:authorization) { create(:authorization) }

    it 'confirmation_token is set after create' do
      expect(authorization.confirmation_token).not_to be_nil
    end
    it 'confirmation_token have 20 characters or more' do
      expect(authorization.confirmation_token.length).to be >= 20
    end
  end
end
