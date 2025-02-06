FactoryBot.define do
  factory :entry do
    association :user
    association :pool
    submitted_at { Time.current }
    paid { false }
  end
end
