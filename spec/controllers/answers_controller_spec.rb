require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:valid_params) { { answer: attributes_for(:answer), question_id: question } }
    let(:invalid_params_with_question) { { answer: attributes_for(:invalid_answer), question_id: question } }
    let(:invalid_params_by_nil_question) { { answer: attributes_for(:answer), question_id: nil } }

    context 'with valid attribute' do
      it 'saves the new answer' do
        expect { post :create, params: valid_params }.to change(question.answers, :count).by(1)
      end

      it 'redirect to associates question' do
        post :create, params: valid_params
        expect(response).to redirect_to question_path(assign(question))
      end
    end

    context 'with invalid attribute' do
      it 'does not save the answer' do
        expect { post :create, params: invalid_params_with_question }.to_not change(Question, :count)
      end
      it 'does not save the answer without question' do
        expect { post :create, params: invalid_params_by_nil_question }.to_not change(Question, :count)
      end
      it 're-render associates question view' do
        post :create, params: { answer: attributes_for(:answer) }
        expect(response).to render_template(question_path(assign(question)))
      end
    end
  end
end
