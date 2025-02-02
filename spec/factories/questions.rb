FactoryBot.define do
  factory :question do
    pool
    sequence(:text) { |n| "#{Faker::Lorem.question}#{n}" }

    trait :with_options do
      after(:create) do |question|
        options = create_list(:option, 4, question: question)
        question.update!(correct_option: options.first)
      end
    end
  end
end
