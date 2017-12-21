require 'rails_helper'

RSpec.describe AnswerMailer, type: :mailer do
  describe '#notifier' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { AnswerMailer.notifier(answer, question.user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notifier')
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.to).to eq([question.user.email])
    end

    it 'renders the body' do
      expect(mail.html_part.decoded).to match('Ваш вопрос получил новый ответ.')
    end
  end
end
