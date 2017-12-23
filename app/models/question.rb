class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user, class_name: 'User'

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  scope :last_day_questions, -> { where(created_at: Time.zone.now.all_day) }
  
  def subscribe_author
    subscriptions.create!(user: user)
  end
  
  def subscribed_by?(user)
    subscriptions.where(user: user).exists?
  end
  
  def find_subscription(user)
    subscriptions.where(user: user).first
  end
end
