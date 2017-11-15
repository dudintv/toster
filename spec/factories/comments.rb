FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Комментарий #{n}" }
    user
  end

  factory :invalid_comment, class: Comment do
    body nil
    user
  end
end
