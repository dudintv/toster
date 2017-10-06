require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:valid_params) { { answer: attributes_for(:answer), question_id: question } }
    let(:invalid_params) { { answer: attributes_for(:invalid_answer), question_id: question } }

    context 'with valid attribute' do
      it 'saves the new answer' do
        expect { post :create, params: valid_params }.to change(question.answers, :count).by(1)
      end

      it 'redirect to associates question' do
        post :create, params: valid_params
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attribute' do
      it 'does not save the answer' do
        invalid_params
        expect { post :create, params: invalid_params }.to_not change(Question, :count)
      end
      it 're-render associates question view' do
        post :create, params: invalid_params
        expect(response).to render_template('questions/show')
      end
    end
  end
end
