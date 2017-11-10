FactoryBot.define do
  factory :vote do
    value 0
    user

    trait :up do
      value 1
    end

    trait :down do
      value(-1)
    end
  end
end
