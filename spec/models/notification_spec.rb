require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build(:notification) }

  describe "has_many" do
    it { should belong_to(:notify_to) }
    it { should belong_to(:notifyed_by) }
  end

  describe "validation" do
    context ":to" do
      it { should validate_presence_of(:to) }
      it { should validate_numericality_of(:to).only_integer }

      it "is invalid when user who notify to is not found" do
        notification.to = notification.to + 100
        notification.valid?
        expect(notification.errors[:notify_to]).to include "must exist"
      end
    end

    context ":by" do
      it { should validate_presence_of(:by) }
      it { should validate_numericality_of(:by).only_integer }

      it "is invalid when user who notifyed by is not found" do
        notification.by = notification.by + 100
        notification.valid?
        expect(notification.errors[:notifyed_by]).to include "must exist"
      end

      it ":to and room owner must be the same" do
        other_room = FactoryBot.create(:room)
        notification.room_id = other_room.id
        notification.valid?
        expect(notification.errors[:room_id]).to include "must be the id of the room owned by the user who received the notification"
      end
    end

    context ":action" do
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
end
