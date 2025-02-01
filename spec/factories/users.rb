FactoryBot.define do
  factory :user do
    sequence(:email) { Faker::Internet.email(name: "#{Faker::Name.first_name}_#{SecureRandom.hex(8)}") }
  end
end
