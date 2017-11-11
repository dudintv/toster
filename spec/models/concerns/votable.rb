require 'rails_helper'

shared_examples_for 'votable' do
  let(:model)   { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:user)    { create(:user) }

  describe '#vote_up' do
    it 'create new vote with value = 1' do
      expect { votable.vote_up(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to eq 1
    end
  end

  describe '#vote_down' do
    it 'create new vote with value = -1' do
      expect { votable.vote_down(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to eq(-1)
    end
  end

  describe '#vote_cancel' do
    let!(:vote) { create(:vote, votable: votable, user: user) }

    it 'cancel vote' do
      votable.vote_cancel(user)
      expect(votable.votes.count).to eq 0
    end
  end

  describe '#sum_value' do
    let!(:votes_up)   { create_list(:vote, 3, :up, votable: votable) }
    let!(:votes_down) { create_list(:vote, 2, :down, votable: votable) }

    it 'return sum all the vote :value' do
      expect(votable.sum_value).to eq 1
    end
  end
end
