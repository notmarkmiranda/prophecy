FactoryBot.define do
  factory :user do
    sequence(:email) { |n| Faker::Internet.email(name: "#{Faker::Name.first_name}_#{n}") }
  end
end
