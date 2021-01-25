require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { FactoryBot.create(:member) }

  it "has valid factory" do
    expect(member).to be_valid
  end

  it "is invalid without user_id" do
    member.user_id = nil
    member.valid?
    expect(member.errors[:user_id]).to include("can't be blank")
  end

  it "is invalid without room_id" do
    member.room_id = nil
    member.valid?
    expect(member.errors[:room_id]).to include("can't be blank")
  end
end
