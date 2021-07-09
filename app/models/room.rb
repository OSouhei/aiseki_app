class Room < ApplicationRecord
  has_many :memberships, class_name: "Member", foreign_key: "room_id", dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :notifications, dependent: :destroy
  has_many :booked, class_name: "Bookmark", foreign_key: "room_id", dependent: :destroy
  has_many :booked_by, through: :booked, source: :user
  belongs_to :owner, class_name: "User", foreign_key: :user_id

  validates :name, presence: true, length: { maximum: 100 }
  validates :theme, presence: true, length: { maximum: 200 }
  validates :message, length: { maximum: 500 }

  def owner?(user)
    owner == user
  end

  def member?(user)
    members.include?(user)
  end

  def booked_by?(user)
    booked_by.include?(user)
  end
end
