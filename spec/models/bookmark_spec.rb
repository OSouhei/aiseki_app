require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let!(:bookmark) { FactoryBot.create(:bookmark) }

  it { should belong_to :user }
  it { should belong_to :room }

  describe "user_id" do
    it { should validate_presence_of(:user_id) }
    it { should validate_numericality_of(:user_id).only_integer }
    it { should validate_uniqueness_of(:user_id).scoped_to(:room_id) }
  end

  describe "room_id" do
    it { should validate_presence_of(:room_id) }
    it { should validate_numericality_of(:room_id).only_integer }
  end
end
