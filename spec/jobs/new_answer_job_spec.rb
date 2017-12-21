require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:answer) { create(:answer) }
  it 'sends daily digest' do
    expect(AnswerMailer).to receive(:notifier).with(answer, answer.question.user).and_call_original
    NewAnswerJob.perform_now(answer)
  end
end
