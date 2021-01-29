require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { FactoryBot.build(:room) }

  it "has valid factory" do
    expect(room).to be_valid
  end

  it "is invalid without title" do
    room.title = "  "
    room.valid?
    expect(room.errors[:title]).to include "can't be blank"
  end

  it "is invalid with more than 30 chars title" do
    room.title = "a" * 31
    room.valid?
    expect(room.errors[:title]).to include "is too long (maximum is 30 characters)"
  end

  it "allow nil for content" do
    room.content = "   "
    expect(room).to be_valid
  end

  it "is invalid with more than 200 chars content" do
    room.content = "a" * 201
    room.valid?
    expect(room.errors[:content]).to include "is too long (maximum is 200 characters)"
  end

  it "is invalid without limit" do
    room.limit = nil
    room.valid?
    expect(room.errors[:limit]).to include "can't be blank"
  end

  it "is invalid with non-number limit" do
    room.limit = "string"
    room.valid?
    expect(room.errors[:limit]).to include "is not a number"
  end

  it "is invalid with non-integer limit" do
    room.limit = 1.5
    room.valid?
    expect(room.errors[:limit]).to include "must be an integer"
  end
end
