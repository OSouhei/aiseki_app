FactoryBot.define do
  factory :room do
    title { "Test Room" }
    content { "This is test room." }
    shop_name { "Orion" }
    date { Time.zone.local(2021, 12, 11, 15, 30) }
    limit { 3 }
    association :owner

    trait :limited do
      limit { 0 }
    end
  end
end
