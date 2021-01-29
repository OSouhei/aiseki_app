FactoryBot.define do
  factory :room do
    title { "Test Room" }
    content { "This is test room. Anyone can join it!" }
    shop_name { "Orion" }
    limit { 3 }
    association :user
  end
end
