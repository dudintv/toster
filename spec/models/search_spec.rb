require 'rails_helper'

RSpec.describe Search do
  describe '.search' do
    %w(Noname Everywhere '').each do |attr|
      it "gets search_object #{attr}" do
        expect(ThinkingSphinx).to receive(:search).with('ask')
        Search.search('ask', attr)
      end
    end

    %w(Questions Answers Comments Users).each do |attr|
      it "gets search_object: #{attr}" do
        expect(attr.singularize.classify.constantize).to receive(:search).with('ask')
        Search.search('ask', attr)
      end
    end
  end
end
