FactoryBot.define do
  factory :room do
    conditions { "MyText" }
    date { "2021-01-16" }
    people_limit { 1 }
    user { nil }
  end
end
