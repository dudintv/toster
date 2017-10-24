require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  it { should have_db_column(:best).of_type(:boolean).with_options(default: false) }

  describe '#set_as_best' do
    let!(:question) { create(:question) }
    before do
      create_list(:answer, 2, question: question)
    end

    it 'change from false to true' do
      expect { question.answers[0].set_as_best }.to change(question.answers[0], :best).to(true)
    end

    it 'there is only one best Answer by Question' do
      question.answers[0].set_as_best
      expect(question.answers[0].reload.best).to eq true
      expect(question.answers[1].reload.best).to eq false
      question.answers[1].set_as_best
      expect(question.answers[0].reload.best).to eq false
      expect(question.answers[1].reload.best).to eq true
    end
  end
end
