require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'get search everywhere with empty search_object' do
      expect(Search).to receive(:search).with('ask', '')
      get :search, params: { search_string: 'ask', search_object: '' }
    end

    it 'get search everywhere with search_object everyqhere' do
      expect(Search).to receive(:search).with('ask', 'Everywhere')
      get :search, params: { search_string: 'ask', search_object: 'Everywhere' }
    end

    %w(Questions Answers Comments Users).each do |attr|
      it "gets search_object: #{attr}" do
        expect(Search).to receive(:search).with('ask', attr)
        get :search, params: { search_string: 'ask', search_object: attr }
      end
    end

    %w(Everywhere Questions Answers Comments Users).each do |attr|
      it 'redirect to search' do
        get :search, params: { search_string: 'ask', search_object: attr }
        expect(response).to render_template :search
      end
    end

    it 'gets search_object: noname' do
      expect(Search).to receive(:search).with('ask', 'Noname')
      get :search, params: { search_string: 'ask', search_object: 'Noname' }
    end
  end
end
