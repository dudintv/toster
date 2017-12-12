require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { described_class }
  let(:guest) { nil }
  let(:user) { create :user }

  permissions :create? do
    it 'not allow to Guest creates comment' do
      expect(subject).not_to permit(guest, Comment)
    end

    it 'allow to User creates comment' do
      expect(subject).to permit(user, Comment)
    end
  end
end
