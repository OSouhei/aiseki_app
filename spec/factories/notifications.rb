FactoryBot.define do
  factory :notification do
    to { FactoryBot.create(:user).id }
    by { FactoryBot.create(:user).id }
    room_id { FactoryBot.create(:room, owner: notify_to).id }
    checked { false }
  end
end
