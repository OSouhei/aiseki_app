FactoryBot.define do
  factory :room do
    name { "test room" }
    theme { "about ruby" }
    message { "developer only." }
    association :owner
  end
end
