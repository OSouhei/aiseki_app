require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { build(:room) }

  describe "has many" do
    context "#memberships" do
      it { should have_many(:memberships).class_name("Member") }
    end

    context "#members" do
      it { should have_many(:members).class_name("User") }
    end

    context "#notifications" do
      it { should have_many(:notifications) }
    end

    context "#booked" do
      it { should have_many(:booked).class_name("Bookmark") }
    end

    context "#booked_by" do
      it { should have_many(:booked_by).class_name("User") }
    end

    context "#owner" do
      it { should belong_to(:owner).class_name("User") }
    end
  end

  describe "validation" do
    context "name" do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_most(100) }
    end

    context "theme" do
      it { should validate_presence_of(:theme) }
      it { should validate_length_of(:theme).is_at_most(200) }
    end

    context "message" do
      it { should validate_length_of(:message).is_at_most(500) }
    end
  end

  describe "method" do
    describe "#owner?" do
      let(:user) { create(:user) }
      let(:user_room) { create(:room, owner: user) }
      let(:room) { create(:room) }

      it "returns true if argument is a room owner" do
        expect(user_room).to be_owner user
      end

      it "returns false if argument is not a room owner" do
        expect(room).to_not be_owner user
      end
    end

    describe "#member?" do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let(:room) { create(:room) }

      before do
        user1.join room
      end

      it "returns true if argument is a member" do
        expect(room).to be_member user1
      end

      it "returns false if argument is not a member" do
        expect(room).to_not be_member user2
      end
    end

    describe "#booked_by?" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:room) { create(:room) }

      before do
        user.book room
      end

      it "returns true if user books the room" do
        expect(room).to be_booked_by user
      end

      it "returns false if user does not book the room" do
        expect(room).to_not be_booked_by other_user
      end
    end
  end
end
