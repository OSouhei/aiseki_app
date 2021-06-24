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
    context "title" do
      it { should validate_presence_of(:title) }
      it { should validate_length_of(:title).is_at_most(30) }
    end

    context "content" do
      it { should validate_length_of(:content).is_at_most(200) }
    end
  end

  context "limit" do
    let(:limited_room) { create(:room, :limited) }

    it { should validate_presence_of(:limit).allow_nil }
    it { should validate_numericality_of(:limit).only_integer }

    it "is invalid when room's member is more than limit" do
      limited_room.members << create(:user)
      limited_room.valid?
      expect(limited_room.errors[:limit]).to include "must be more than members count"
    end
  end

  describe "method" do
    describe "#search" do
      let!(:room1) { create(:room, content: "this is room1") }
      let!(:room2) { create(:room, content: "this is room2") }
      let!(:room3) { create(:room, content: "this is room3") }

      context "when term is nil" do
        it "returns all rooms" do
          expect(described_class.search("")).to eq described_class.all
        end

        it "returns all rooms with default argument" do
          expect(described_class.search).to eq described_class.all
        end
      end

      context "term is present" do
        it "returns search result" do
          expect(described_class.search("room1")).to include room1
        end

        it "returns search results" do
          aggregate_failures do
            expect(described_class.search("room")).to include room1
            expect(described_class.search("room")).to include room2
            expect(described_class.search("room")).to include room3
          end
        end

        it "searches case insensitive" do
          expect(described_class.search("ROOM1")).to include room1
        end
      end
    end

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

    describe "#limited?" do
      let(:room) { create(:room) }
      let(:limited_room) { create(:room, :limited) }

      it "returns true if argument is limited" do
        expect(limited_room).to be_limited
      end

      it "returns false if argument is not limited" do
        expect(room).to_not be_limited
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

    describe "#display_time" do
      it "returns formatted time" do
        room.update(date: Time.zone.local(2021, 12, 11, 15, 30))
        expect(room.display_time).to eq "2021/12/11 15:30"
      end

      it "returns string when date is nil" do
        room.update(date: nil)
        expect(room.display_time).to eq "日付が設定されていません。"
      end
    end
  end
end
