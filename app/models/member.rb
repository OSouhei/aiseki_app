class Member < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :room_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :room_id }
  validate :owner_is_not_member

  def owner_is_not_member
    return if room.nil?

    errors.add(:user_id, " can not be equal to member_id") if user_id == room.owner.id
  end
end
