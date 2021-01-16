require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { FactoryBot.build(:room) }

  it "has valid factory" do
    expect(room).to be_valid
  end

  it "is invalid without associated user" do
    room.user = nil
    expect(room).to be_invalid
  end

  it "is invalid without date" do
    room.date = nil
    expect(room).to be_invalid
  end
end
