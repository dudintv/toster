FactoryGirl.define do
  sequence(:title) { |n| "Заголовок #{n}" }
  sequence(:body) { |n| "Подробности #{n}" }

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
    user
  end
end
