class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscriptions.includes(:user).each do |subscription|
      if answer.user != subscription.user
        AnswerMailer.notifier(answer, subscription.user).deliver_later
      end
    end
  end
end
