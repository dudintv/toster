require 'rails_helper'

describe 'Question API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list :question, 2 }
      let(:question) { questions.first }
      let!(:answer) { create :answer, question: question }

      before do
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size 2
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      # context 'answers' do
      #   it 'included in question object' do
      #     expect(response.body).to have_json_size(1).at_path('0/answers')
      #   end

      #   %w(id body created_at updated_at).each do |attr|
      #     it "contains #{attr}" do
      #       expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
      #     end
      #   end
      # end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let!(:questions) { create_list(:question, 2) }
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/1', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions/1', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comment) { create(:comment, commentable: question, user: question.user) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        it 'has attachment url attr' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/url')
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body).each do |attr|
          it "comment contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions/', params: { action: :create, format: :json, question: attributes_for(:question) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions/', params: { action: :create, access_token: '123', format: :json, question: attributes_for(:question) }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      
      before do
        post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token, question: attributes_for(:question) }
      end

      it 'returns success' do
        expect(response).to be_success
      end

      it 'create question' do
        expect do
          post '/api/v1/questions/', params: { action: :create, format: :json, access_token: access_token.token, question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end
    end
  end
end
