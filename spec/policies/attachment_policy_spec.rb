require 'rails_helper'

RSpec.describe AttachmentPolicy do
  subject { described_class }

  let(:guest) { nil }
  let(:user) { create :user }
  let(:author) { create :user }
  let(:question) { create :question, user: author }
  let(:attachment) { create :attachment, attachable: question }

  permissions :destroy? do
    it 'not allow to Guest edit and destroy attachment' do
      expect(subject).not_to permit(guest, attachment)
    end

    it 'not allow Non-Author destroy attachment' do
      expect(subject).not_to permit(user, attachment)
    end

    it 'allow Author of answer destroy own attachment' do
      expect(subject).to permit(author, attachment)
    end
  end
end
