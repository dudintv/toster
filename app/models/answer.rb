class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question, touch: true
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc, created_at: :asc) }

  after_commit :notify_subscribers, on: :create

  def set_as_best
    Answer.record_timestamps = false
    Answer.transaction do
      question.answers.update_all best: false
      update!(best: true) unless best
    end
    Answer.record_timestamps = true
  end

  def notify_subscribers
    NewAnswerJob.perform_later(self)
  end
end
