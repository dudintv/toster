require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:valid_params) { { question_id: question.id, comment: attributes_for(:comment).merge(commentable_type: 'Question', commentable_id: question.id) } }

  describe 'POST #create' do
    let(:create_valid_comment) { post :create, params: valid_params, format: :js }

    sign_in_user

    it 'saves new comment' do
      expect { create_valid_comment }.to change(question.comments, :count).by(1)
    end

    it 'render create view' do
      create_valid_comment
      expect(response).to render_template :create
    end
  end
end
