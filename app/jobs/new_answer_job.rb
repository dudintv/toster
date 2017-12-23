class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscribers.each do |user|
      AnswerMailer.notifier(answer, user).try(:deliver_later) unless answer.user_id == user.id
    end
  end
end
