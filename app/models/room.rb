class Room < ApplicationRecord
  has_many :memberships, class_name: "Member", foreign_key: "room_id", dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :notifications, dependent: :destroy
  has_many :booked, class_name: "Bookmark", foreign_key: "room_id", dependent: :destroy
  has_many :booked_by, through: :booked, source: :user
  belongs_to :owner, class_name: "User", foreign_key: :user_id

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 200 }
  validates :limit, presence: true, numericality: { only_integer: true }
  validate :member_limit

  def self.search(term = "")
    term.blank? ? Room.all : Room.where("content LIKE ?", "%#{term}%")
  end

  def owner?(usr)
    owner == usr
  end

  def member?(user)
    members.include?(user)
  end

  def limited?
    limit <= members.count
  end

  def member_limit
    errors.add(:limit, "must be more than members count") if limit && members.count > limit
  end

  def booked_by?(user)
    booked_by.include?(user)
  end
end
