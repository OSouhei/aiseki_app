class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true, numericality: { only_integer: true }, uniqueness: { scope: :followed_id }
  validates :followed_id, presence: true, numericality: { only_integer: true }
  # 自身をフォローできない
  validate :follower_not_equal_followed

  def follower_not_equal_followed
    errors.add(:follower_id, "must not be equal to :followed_id") if follower_id == followed_id
  end
end
