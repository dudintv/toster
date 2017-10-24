class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def set_as_best
    Answer.record_timestamps = false
    Answer.transaction do
      question.answers.update_all best: false
      update! best: true unless best
    end
    Answer.record_timestamps = true
  end
end
