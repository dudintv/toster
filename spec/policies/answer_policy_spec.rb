require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }
  let(:guest) { nil }
  let(:user) { create :user }
  let(:author) { create :user }
  let(:author_of_question) { create :user }
  let(:question) { create :question, user: author_of_question }
  let(:answer) { create :answer, user: author, question: question }

  permissions :create? do
    it 'not allow to Guest creates answer' do
      expect(subject).not_to permit(guest, Answer)
    end

    it 'allow to User creates answer' do
      expect(subject).to permit(user, Answer)
    end
  end

  permissions :update? do
    it 'not allow to Guest edit and update answer' do
      expect(subject).not_to permit(guest, answer)
    end

    it 'not allow Non-Author edit and update answer' do
      expect(subject).not_to permit(user, answer)
    end

    it 'allow Author of answer edit and update own answer' do
      expect(subject).to permit(author, answer)
    end
  end

  permissions :destroy? do
    it 'not allow to Guest edit and destroy answer' do
      expect(subject).not_to permit(guest, answer)
    end

    it 'not allow Non-Author destroy answer' do
      expect(subject).not_to permit(user, answer)
    end

    it 'allow Author of answer destroy own answer' do
      expect(subject).to permit(author, answer)
    end
  end

  permissions :set_as_best? do
    it 'not allow to Guest answer set as best' do
      expect(subject).not_to permit(guest, answer)
    end

    it 'not allow Non-Author question set as best' do
      expect(subject).not_to permit(user, answer)
    end

    it 'allow Author of question set as best' do
      expect(subject).to permit(author_of_question, answer)
    end
  end
end
