FactoryBot.define do
  factory :pool do
    sequence(:name) { "#{Faker::Book.title}#{SecureRandom.hex(8)}" }
    user
    price { rand(0..100) }
    allow_multiple_entries { [ true, false ].sample }
    locked_at { 1.month.from_now.change(hour: 12, minute: 0) }
  end
end
