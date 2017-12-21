require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 2, user: user) }

  it 'send daily digest' do
    expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
    DailyDigestJob.perform_now
  end
end
