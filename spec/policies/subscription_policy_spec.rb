require 'rails_helper'

RSpec.describe SubscriptionPolicy do
  subject { described_class }
  let(:guest) { nil }
  let!(:user) { create :user }
  let(:author) { create :user }
  let(:question) { create :question }
  let(:subscription) { create :subscription, user: author, question: question }

  permissions :create? do
    it 'not allow to Guest creates subscription' do
      expect(subject).not_to permit(guest, Subscription)
    end

    it 'allow to User creates subscription' do
      expect(subject).to permit(user, Subscription)
    end
  end

  permissions :destroy? do
    it 'not allow to Guest destroy subscription' do
      expect(subject).not_to permit(guest, subscription)
    end

    it 'not allow non-author destroy subscription' do
      expect(subject).not_to permit(user, subscription)
    end

    it 'allow owner of subscription destroy own subscription' do
      expect(subject).to permit(author, subscription)
    end
  end
end
