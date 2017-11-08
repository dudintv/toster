require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      let!(:user) { create(:user) }
      let!(:my_question) { create(:question, user: user) }
      let!(:foreign_question) { create(:question) }
      let!(:my_attachment) { create(:attachment, attachable: my_question) }
      let!(:foreign_attachment) { create(:attachment, attachable: foreign_question) }

      before do
        sign_in user
      end

      context 'As author' do
        let(:delete_my_attachment) { delete :destroy, params: { id: my_attachment.id }, format: :js }

        it 'deletes my attachment' do
          expect { delete_my_attachment }.to change(my_question.attachments, :count).by(-1)
        end

        it 'render destroy.js' do
          delete_my_attachment
          expect(response).to render_template('attachments/destroy')
        end
      end

      context 'As non-author user' do
        let(:delete_foreign_attachment) { delete :destroy, params: { id: foreign_attachment.id }, format: :js }

        it 'does not delete foreign attachment' do
          expect { delete_foreign_attachment }.to_not change(Attachment, :count)
        end

        it 'render destroy.js' do
          delete_foreign_attachment
          expect(response).to render_template 'attachments/destroy'
        end
      end
    end

    context 'Guest user' do
      let!(:attachment) { create(:attachment) }
      let(:try_delete_attachment) { delete :destroy, params: { id: attachment.id }, format: :js }

      it 'does not delete an attachment' do
        expect { try_delete_attachment }.to_not change(Attachment, :count)
      end

      it '401 status' do
        try_delete_attachment
        expect(response.status).to eq 401
      end
    end
  end
end
