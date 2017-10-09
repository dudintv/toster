FactoryGirl.define do
  factory :answer do
    body { |n| "Ответ #{n}" }
    question 
  end

  factory :invalid_answer, class: Answer do
    body nil
    question
  end
end
