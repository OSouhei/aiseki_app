require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "has_many" do
    it { should belong_to :follower }
    it { should belong_to :followed }
  end

  describe "validation" do
    context "follower_id" do
      it { should validate_presence_of :follower_id }
      it { should validate_numericality_of(:follower_id).only_integer }
      it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }

      # 自分をフォローできない
      it "not equal to followed_id" do
        relationship = build(:relationship, follower_id: 1, followed_id: 1)
        relationship.valid?
        expect(relationship.errors[:follower_id]).to include "must not be equal to :followed_id"
      end
    end

    context "followed_id" do
      it { should validate_presence_of :followed_id }
      it { should validate_numericality_of(:follower_id).only_integer }
    end
  end
end
