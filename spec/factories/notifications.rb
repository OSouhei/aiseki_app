FactoryBot.define do
  factory :notification do
    to { FactoryBot.create(:user).id }
    by { FactoryBot.create(:user).id }
    room_id { nil }
    checked { false }
    action { "join" }
  end
end
