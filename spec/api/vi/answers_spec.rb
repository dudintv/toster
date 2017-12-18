require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create :question }

  describe 'GET /index' do
    def make_request(params = {})
      question = params[:question] || create(:question)
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:answers) { create_list :answer, 2, question: question }
      let(:answer) { answers.first }

      before do
        make_request access_token: access_token.token, question: question
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end
      it 'returns list of answers' do
        expect(response.body).to have_json_size 2
      end
      %w(id body).each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end
    end
  end

  describe 'GET /show' do
    def make_request(params = {})
      answer = params[:answer] || create(:answer)
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer) { create(:answer, question: question) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:comment, commentable: answer, user: question.user) }

      before do
        make_request access_token: access_token.token, answer: answer
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end
      
      context 'attachments' do
        it 'contains' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end
        it 'contains ulr' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/url')
        end
      end

      context 'comments' do
        it 'contains' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end
        %w(id body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    def make_request(params = {})
      question = params[:question] || create(:question)
      post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json, answer: attributes_for(:answer) }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        make_request access_token: access_token.token
      end
      
      it 'returns 200 status code' do
        expect(response).to be_success
      end
      it 'creates new answer' do
        expect { make_request access_token: access_token.token }.to change(Answer, :count).by(1)
      end
    end  
  end
end
