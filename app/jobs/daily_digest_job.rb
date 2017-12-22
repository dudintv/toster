class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.last_day_questions.to_a
    User.find_each.each do |user|
      DailyMailer.digest(user, questions).deliver_later
    end
  end
end
