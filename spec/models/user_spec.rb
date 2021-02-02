require 'rails_helper'

RSpec.describe User, type: :model do
  describe "has_many" do
    let(:user) { create(:user) }
    let(:user_room) { create(:room, owner: user) }

    context "rooms" do
      let(:other_room) { create(:room) }

      it { should have_many(:rooms) }

      it "includes user's rooms" do
        expect(user.rooms).to include user_room
      end

      it "does not includes other user's rooms" do
        expect(user.rooms).to_not include other_room
      end

      it { should have_many(:joining_rooms) }

      it { should have_many(:joining).class_name("Room") }

      it "includes joining rooms" do
        user.join(other_room)
        expect(user.joining).to include other_room
      end

      it "does not include non-joining rooms" do
        expect(user.joining).to_not include other_room
      end
    end

    context "notifications" do
      let(:other_user) { create(:user) }

      it { should have_many(:notifications).class_name("Notification") }

      it "has user notifications" do
        expect {
          other_user.join(user_room) # ユーザーが部屋に参加すると通知が作成される
        }.to change(Notification, :count).by(1)
      end
    end

    context "Bookmark" do
      it { should have_many(:bookmarks) }
      it { should have_many(:booked_rooms).class_name("Room") }
    end
  end

  describe "validation" do
    let(:user) { build(:user) }

    context "name" do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_most(50) }
    end

    context "email" do
      it { should validate_presence_of(:email) }
      it { should validate_length_of(:email).is_at_most(255) }
      it { should validate_uniqueness_of(:email).case_insensitive }

      it "is invalid with invalid adress" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          user.valid?
          expect(user).to be_invalid
        end
      end
    end

    context "password" do
      it { should validate_presence_of(:password) }
    end
  end
end
