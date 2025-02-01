FactoryBot.define do
  factory :membership do
    user
    association :joinable, factory: :pool
    role { :participant }
  end
end
