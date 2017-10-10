FactoryGirl.define do
  sequence(:title) { |n| "Заголовок #{n}" }
  sequence(:body) { |n| "Подробности #{n}" }

  factory :question do
    title
    body
    # association :user
    user
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
    # association :user
    user
  end
end
