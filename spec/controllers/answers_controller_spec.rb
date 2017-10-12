require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:valid_params) { { answer: attributes_for(:answer), question_id: question } }
    let(:invalid_params) { { answer: attributes_for(:invalid_answer), question_id: question } }
    sign_in_user

    context 'with valid attribute' do
      it 'saves the new answer' do
        expect { post :create, params: valid_params }.to change(question.answers, :count).by(1)
      end

      it 'saves with current user as author' do
        post :create, params: valid_params
        expect(Answer.last.user_id).to eq @user.id
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

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      let!(:user) { create(:user) }
      before do
        sign_in user
      end

      context 'As author' do
        let!(:my_answer) do
          my_answer = create(:answer)
          user.answers << my_answer
          my_answer
        end

        it 'deletes my answer' do
          expect { delete :destroy, params: { question_id: my_answer.question.id, id: my_answer.id } }.to change(user.answers, :count).by(-1)
          expect(response).to redirect_to question_path(my_answer.question)
        end
      end

      context 'As non-author user' do
        let!(:foreign_answer) { create(:answer) }

        it 'does not delete foreign answer' do
          expect { delete :destroy, params: { question_id: foreign_answer.question.id, id: foreign_answer.id } }.to_not change(Answer, :count)
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Guest user' do
      let!(:answer) { create(:answer) }

      it 'does not delete a answer' do
        expect { delete :destroy, params: { question_id: answer.question.id, id: answer.id } }.to_not change(Answer, :count)
      end

      it 'redirected to login page' do
        delete :destroy, params: { question_id: answer.question.id, id: answer.id }
        expect(flash[:alert]).to eq 'Вам необходимо войти в систему или зарегистрироваться.'
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
