require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { FactoryBot.build(:notification) }

  it "has valid factory" do
    expect(notification).to be_valid
  end

  it "is invalid without :to" do
    notification.to = nil
    notification.valid?
    expect(notification.errors[:to]).to include "can't be blank"
  end

  it "is invalid with non-number :to" do
    notification.to = "foo"
    notification.valid?
    expect(notification.errors[:to]).to include "is not a number"
  end

  it "is invalid with non-integer :to" do
    notification.to = 1.1
    notification.valid?
    expect(notification.errors[:to]).to include "must be an integer"
  end

  it "is invalid when user who notify to is not found" do
    notification.to = notification.to + 100
    notification.valid?
    expect(notification.errors[:notify_to]).to include "must exist"
  end

  it "is invalid without :by" do
    notification.by = nil
    notification.valid?
    expect(notification.errors[:by]).to include "can't be blank"
  end

  it "is invalid with non-number :by" do
    notification.by = "foo"
    notification.valid?
    expect(notification.errors[:by]).to include "is not a number"
  end

  it "is invalid with non-integer :by" do
    notification.by = 1.3
    notification.valid?
    expect(notification.errors[:by]).to include "must be an integer"
  end

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
