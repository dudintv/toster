class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user, :commentable, :commentable_type, :body, presence: true
end
