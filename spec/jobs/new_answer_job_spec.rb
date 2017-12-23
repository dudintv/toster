require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:question) { create(:question) }
  let(:subscriptions) { create_pair(:subscription, question: question) }
  let(:foreign_users) { create_list(:user, 2) }
  let!(:answer) { create(:answer, question: question) }

  it 'sends new answer to all subscribers' do
    question.subscriptions.each do |subscription|
      expect(AnswerMailer).to receive(:notifier).with(answer, subscription.user).and_call_original
    end
    NewAnswerJob.perform_now(answer)
  end

  it 'not sends to not-subscribers' do
    foreign_users.each do |fuser|
      expect(AnswerMailer).to_not receive(:notifier).with(answer, fuser)
    end
    NewAnswerJob.perform_now(answer)
  end
end
