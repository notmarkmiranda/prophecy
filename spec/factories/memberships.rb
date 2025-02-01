FactoryBot.define do
  factory :membership do
    user
    association :memberable, factory: :pool
    role { :participant }
  end
end
