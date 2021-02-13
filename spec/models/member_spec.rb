require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { FactoryBot.create(:member) }

  it "has valid factory" do
    expect(member).to be_valid
  end

  it "is invalid without user_id" do
    member.user_id = nil
    member.valid?
    expect(member.errors[:user_id]).to include("を入力してください")
  end

  it "is invalid without room_id" do
    member.room_id = nil
    member.valid?
    expect(member.errors[:room_id]).to include("を入力してください")
  end

  it "is invalid when room owner is included in members" do
    user = FactoryBot.create(:user)
    room = FactoryBot.create(:room, owner: user)
    member = FactoryBot.build(:member, room: room, user: user)
    expect(member).to be_invalid
  end

  it "does not allow duplicated record" do
    user = FactoryBot.create(:user)
    room = FactoryBot.create(:room)
    FactoryBot.create(:member, user: user, room: room)
    member.room_id = room.id
    member.user_id = user.id
    member.valid?
    expect(member).to be_invalid
  end
end
