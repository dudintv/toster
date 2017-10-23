require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    let(:valid_params) { { answer: attributes_for(:answer), question_id: question } }
    let(:invalid_params) { { answer: attributes_for(:invalid_answer), question_id: question } }
    sign_in_user

    context 'with valid attribute' do
      let(:create_valid_answer) { post :create, params: valid_params, format: :js }

      it 'saves the new answer' do
        expect { create_valid_answer }.to change(question.answers, :count).by(1)
      end

      it 'saves with current user as author' do
        create_valid_answer
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'redirect to associates question' do
        create_valid_answer
        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid attribute' do
      let(:create_invalid_answer) { post :create, params: invalid_params, format: :js }

      it 'does not save the answer' do
        expect { create_invalid_answer }.to_not change(Question, :count)
      end

      it 're-render associates question view' do
        create_invalid_answer
        expect(response).to render_template('answers/create')
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
        let!(:my_answer) { create(:answer, user: user) }
        let(:delete_my_answer) { delete :destroy, params: { question_id: my_answer.question.id, id: my_answer.id }, format: :js }

        it 'deletes my answer' do
          expect { delete_my_answer }.to change(user.answers, :count).by(-1)
        end

        it 'render destroy.js' do
          delete_my_answer
          expect(response).to render_template('answers/destroy')
        end
      end

      context 'As non-author user' do
        let!(:foreign_answer) { create(:answer) }
        let(:delete_foreign_answer) { delete :destroy, params: { question_id: foreign_answer.question.id, id: foreign_answer.id }, format: :js }

        it 'does not delete foreign answer' do
          expect { delete_foreign_answer }.to_not change(Answer, :count)
        end

        it 'render destroy.js' do
          delete_foreign_answer
          expect(response).to render_template 'answers/destroy'
        end
      end
    end

    context 'Guest user' do
      let!(:answer) { create(:answer) }
      let(:guest_try_delete_answer) { delete :destroy, params: { question_id: answer.question.id, id: answer.id } }

      it 'does not delete a answer' do
        expect { guest_try_delete_answer }.to_not change(Answer, :count)
      end

      it 'redirected to login page' do
        guest_try_delete_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
