FactoryBot.define do
  factory :group do
    name { "#{Faker::Sports::Football.team}#{rand(100000)}" }
    user
  end
end
