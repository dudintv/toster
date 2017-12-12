require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class }
  let(:guest) { nil }
  let(:user) { create :user }
  let(:author) { create :user }
  let(:question) { create :question, user: author }

  permissions :index?, :show? do
    it 'allow to Guest see all questions' do
      expect(subject).to permit(guest, Question)
    end

    it 'allow to User see all questions' do
      expect(subject).to permit(user, Question)
    end
  end

  permissions :new?, :create? do
    it 'allow to Guest creates questions' do
      expect(subject).not_to permit(guest, Question)
    end

    it 'allow to User creates questions' do
      expect(subject).to permit(user, Question)
    end
  end

  permissions :edit?, :update? do
    it 'not allow to Guest edit and update questions' do
      expect(subject).not_to permit(guest, question)
    end

    it 'not allow non-author edit and update question' do
      expect(subject).not_to permit(user, question)
    end

    it 'allow author of question edit and update own question' do
      expect(subject).to permit(author, question)
    end
  end

  permissions :destroy? do
    it 'not allow to Guest edit and destroy questions' do
      expect(subject).not_to permit(guest, question)
    end

    it 'not allow non-author destroy question' do
      expect(subject).not_to permit(user, question)
    end

    it 'allow author of question destroy own question' do
      expect(subject).to permit(author, question)
    end
  end
end
