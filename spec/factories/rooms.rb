FactoryBot.define do
  factory :room do
    conditions { "engineer only!" }
    date { "2021-01-16" }
    shop_name { "Orion" }
    people_limit { 10 }
    association :user
  end
end
