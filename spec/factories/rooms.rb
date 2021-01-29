FactoryBot.define do
  factory :room do
    title { "Test Room" }
    content { "This is test room." }
    shop_name { "Orion" }
    limit { 3 }
    association :user
  end
end
