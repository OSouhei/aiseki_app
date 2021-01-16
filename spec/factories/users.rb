FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { "password" }

    trait :faker_name do
      name { Faker::Name.name }
    end
  end
end
