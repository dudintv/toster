require 'rails_helper'

shared_examples_for 'commentable' do
  it { should have_many(:comments).dependent(:destroy) }
  # let(:model)   { described_class }
  # let(:votable) { create(model.to_s.underscore.to_sym) }
  # let(:user)    { create(:user) }
end
