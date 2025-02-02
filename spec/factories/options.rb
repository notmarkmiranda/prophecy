FactoryBot.define do
  factory :option do
    question
    sequence(:text) { |n| "#{Faker::Lorem.sentence(word_count: 3)}#{n}" }
  end
end
