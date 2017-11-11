module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create(value: 1, user: user)
  end

  def vote_down(user)
    votes.create(value: -1, user: user)
  end

  def vote_cancel(user)
    votes.find_by(user: user).destroy if votes.exists?(user: user)
  end

  def sum_value
    votes.sum(:value)
  end
end
