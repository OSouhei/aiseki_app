require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { FactoryBot.build(:room) }
  let(:user) { FactoryBot.create(:user) }

  it "has valid factory" do
    expect(room).to be_valid
  end

  it "is invalid without associated user" do
    room.user = nil
    room.valid?
    expect(room.errors[:user]).to include("must exist")
  end

  it "is invalid without date" do
    room.date = nil
    room.valid?
    expect(room.errors[:date]).to include("can't be blank")
  end

  it "is invalid without shop_name" do
    room.shop_name = "   "
    room.valid?
    expect(room.errors[:shop_name]).to include("can't be blank")
  end

  it "is invalid with too many members" do
    room.save
    room.people_limit = 0
    room.members << user
    room.valid?
    expect(room.errors[:people_limit]).to include("is too many")
  end
end
