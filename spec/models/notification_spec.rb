require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build(:notification) }

  describe "has_many" do
    it { should belong_to(:notify_to) }
    it { should belong_to(:notifyed_by) }
  end

  describe "validation" do
    context "to" do
      it { should validate_presence_of(:to) }
      it { should validate_numericality_of(:to).only_integer }

      it "is invalid when user who notify to is not found" do
        notification.to = notification.to + 100
        notification.valid?
        expect(notification.errors[:notify_to]).to include "を入力してください"
      end
    end

    context "by" do
      it { should validate_presence_of(:by) }
      it { should validate_numericality_of(:by).only_integer }

      it "is invalid when user who notifyed by is not found" do
        notification.by = notification.by + 100
        notification.valid?
        expect(notification.errors[:notifyed_by]).to include "を入力してください"
      end
    end

    context "action" do
      it { should validate_presence_of(:action) }

      it "accept valid value :join" do
        notification.action = "join"
        expect(notification).to be_valid
      end

      it "accept valid value :bookmark" do
        notification.action = "bookmark"
        expect(notification).to be_valid
      end

      it "is one of the actions" do
        notification.action = "joining"
        notification.valid?
        expect(notification.errors[:action]).to include "must be one of the value (join bookmark)"
      end
    end
  end

  describe "method" do
    context "#room" do
      let(:room) { create(:room) }
      let(:notification) { create(:notification, room_id: room.id) }

      it "returns room" do
        expect(notification.room).to eq room
      end

      it "returns nil when room is not found" do
        notification.room_id = 1000
        expect(notification.room).to be_nil
      end
    end
  end
end
