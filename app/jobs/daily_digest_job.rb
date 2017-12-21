class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform
    questions = Question.last_day_questions
    User.find_each.each do |user|
      DailyMailer.digest(user, questions).deliver_now
    end
  end
end
