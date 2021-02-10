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
    end

    context "followed_id" do
      it { should validate_presence_of :followed_id }
      it { should validate_numericality_of(:follower_id).only_integer }
    end
  end
end
