FactoryBot.define do
  factory :room do
    conditions { "engineer only!" }
    date { "2021-01-16" }
    people_limit { 1 }
    association :user
  end
end