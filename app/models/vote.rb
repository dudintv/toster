class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true
  validates :value, inclusion: { in: -1..1 }
end
