FactoryBot.define do
  factory :user, aliases: [:owner] do
    name { "Test User" }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { "password" }

    trait :profile_image do
      profile_image { File.new(Rails.root.join("spec/files/test_image.jpg")) }
    end
  end
end
