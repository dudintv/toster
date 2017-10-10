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
      it 'saves the new question' do
        expect { post :create, params: { question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'wit invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before do
        @user = create(:user)
        sign_in @user
        @my_question = create(:question)
        @user.questions << @my_question
        @foreign_question = create(:question)
      end

      it 'deletes my question' do
        expect { delete :destroy, params: { id: @my_question.id } }.to change(@user.questions, :count).by(-1)
      end

      it 'does not delete foreign question' do
        expect { delete :destroy, params: { id: @foreign_question.id } }.to_not change(@user.questions, :count)
      end
    end

    context 'Guest user' do
      it 'does not delete a question' do
        question = create(:question)
        expect { delete :destroy, params: { id: question.id } }.to_not change(Question, :count)
      end
    end
  end
end
