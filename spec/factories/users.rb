FactoryBot.define do
  factory :user, aliases: [:owner] do
    name { "Test User" }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { "password" }
  end
end
