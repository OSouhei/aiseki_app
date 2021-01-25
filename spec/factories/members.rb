FactoryBot.define do
  factory :member do
    association :room
    association :user
  end
end
