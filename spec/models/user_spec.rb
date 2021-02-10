require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  describe "has_many" do
    let(:other_user) { create(:user) }
    let(:user_room) { create(:room, owner: user) }

    context "#rooms" do
      it { should have_many(:rooms) }

      it "includes user's rooms" do
        expect(user.rooms).to include user_room
      end

      it "does not includes other user's rooms" do
        expect(user.rooms).to_not include room
      end
    end

    context "#joining_rooms" do
      it { should have_many(:joining_rooms) }
    end

    context "#joining" do
      it { should have_many(:joining).class_name("Room") }

      it "includes joining rooms" do
        user.join(room)
        expect(user.joining).to include room
      end

      it "does not include non-joining rooms" do
        expect(user.joining).to_not include room
      end
    end

    context "#active_notifications" do
      let(:active_notification) { create(:notification, by: user.id) }

      it { should have_many(:active_notifications) }

      it "includes notifications by user" do
        expect(user.active_notifications).to include active_notification
      end
    end

    context "#passive_notifications" do
      let(:passive_notification) { create(:notification, to: user.id) }

      it { should have_many(:passive_notifications) }

      it "include notifications to user" do
        expect(user.passive_notifications).to include passive_notification
      end
    end

    context "#notifications" do
      let(:notification) { create(:notification, to: user.id) }

      it { should have_many(:notifications) }

      it "include notifications to user" do
        expect(user.notifications).to include notification
      end
    end

    context "#bookmarks" do
      let!(:bookmark) { create(:bookmark, user: user, room: room) }

      it { should have_many(:bookmarks) }

      it "user has bookmarks" do
        expect(user.bookmarks).to include bookmark
      end
    end

    context "#booked_rooms" do
      let!(:bookmark) { create(:bookmark, user: user, room: room) }

      it { should have_many(:booked_rooms).class_name("Room") }

      it "user has booked rooms" do
        expect(user.booked_rooms).to include room
      end
    end

    context "active_relationships" do
      it { should have_many :active_relationships }
    end

    context "passive_relationships" do
      it { should have_many :passive_relationships }
    end

    context "follower" do
      let(:other_user) { create(:user) }
      let!(:relationship) { create(:relationship, follower_id: other_user.id, followed_id: user.id) }

      it { should have_many :follower }

      it "has many follower" do
        expect(user.follower).to include other_user
      end
    end

    context "followed" do
      let(:other_user) { create(:user) }
      let!(:relationship) { create(:relationship, follower_id: user.id, followed_id: other_user.id) }

      it { should have_many :following }

      it "has many following" do
        expect(user.following).to include other_user
      end
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

    context "profile_image" do
      it "is invalid with invalid extension" do
        user.profile_image = File.new("spec/files/test.txt")
        user.valid?
        expect(user.errors[:profile_image]).to include "You are not allowed to upload \"txt\" files, allowed types: jpg, jpeg, gif, png"
      end
    end
  end

  describe "methods" do
    context "#join" do
      let(:limited_room) { FactoryBot.create(:room, :limited) }

      it "join room" do
        user.join(room)
        expect(user.joining).to include room
      end

      it "create notification" do
        expect {
          user.join(room)
        }.to change(Notification, :count).by(1)
      end

      it "return false when argument is nil" do
        expect {
          expect(user.join(nil)).to be_falsey
        }.to_not change(Notification, :count)
      end

      it "returns false when room is limited" do
        expect {
          expect(user.join(limited_room)).to be_falsey
        }.to_not change(Notification, :count)
      end
    end

    context "#exit" do
      context "when user is member of room" do
        before do
          user.join(room)
        end

        it "exit room" do
          user.exit(room)
          expect(user.joining).to_not include room
        end

        it "delete member" do
          expect {
            user.exit(room)
          }.to change(Member, :count).by(-1)
        end
      end

      context "when user is not member of room" do
        it "return false" do
          expect(user.exit(room)).to be_falsey
        end
      end
    end

    context "#book" do
      it "create bookmark" do
        expect {
          user.book room
        }.to change(Bookmark, :count).by(1)
      end

      it "bookmark a room" do
        user.book room
        expect(user.booked_rooms).to include room
      end
    end

    context "#unbook" do
      it "destroy bookmark" do
        user.book room
        expect {
          user.unbook room
        }.to change(Bookmark, :count).by(-1)
      end

      it "unbook a room" do
        user.book room
        user.unbook room
        expect(user.booked_rooms).to_not include room
      end
    end

    context "#follow" do
      let(:other_user) { create(:user) }

      it "create relationship" do
        expect {
          user.follow other_user
        }.to change(Relationship, :count).by(1)
      end

      it "follow a user" do
        user.follow other_user
        expect(user.following).to include other_user
      end
    end

    context "#unfollow" do
      let(:other_user) { create(:user) }

      it "destroy relationship" do
        user.follow other_user
        expect {
          user.unfollow other_user
        }.to change(Relationship, :count).by(-1)
      end

      it "unfollow a user" do
        user.follow other_user
        user.unfollow other_user
        expect(user.following).to_not include other_user
      end
    end

    context "#following?" do
      let(:other_user) { create(:user) }

      it "returns true when user is following other_user" do
        user.follow other_user
        expect(user).to be_following other_user
      end

      it "returns false when user is not following other_user" do
        user.unfollow other_user
        expect(user).to_not be_following other_user
      end
    end
  end
end
