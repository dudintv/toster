require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'populate @question of question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_question) { post :create, params: { question: attributes_for(:question) } }

      it 'saves the new question' do
        expect { create_question }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        create_question
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'current user as author' do
        create_question
        expect(assigns(:question).user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, params: { question: attributes_for(:invalid_question) } }

      it 'does not save the question' do
        expect { create_invalid_question }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      let!(:user) { create(:user) }
      let!(:my_question) { create(:question, user: user) }
      let!(:foreign_question) { create(:question) }

      before do
        sign_in user
      end

      context 'As author' do
        it 'deletes my question' do
          expect { delete :destroy, params: { id: my_question } }.to change(user.questions, :count).by(-1)
        end
      end

      context 'As non-author user' do
        it 'does not delete foreign question' do
          expect { delete :destroy, params: { id: foreign_question } }.to_not change(Question, :count)
        end
      end
    end

    context 'Guest user' do
      let!(:question) { create(:question) }

      it 'does not delete a question' do
        expect { delete :destroy, params: { id: question.id } }.to_not change(Question, :count)
      end

      it 'redirect to login page' do
        delete :destroy, params: { id: question.id }
        expect(flash[:alert]).to eq 'Вам необходимо войти в систему или зарегистрироваться.'
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
