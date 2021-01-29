class Room < ApplicationRecord
  has_many :memberships, class_name: "Member", foreign_key: "room_id", dependent: :destroy
  has_many :members, through: :memberships, source: :user
  belongs_to :user

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 200 }
  validates :limit, presence: true, numericality: { only_integer: true }

  def self.search(term = "")
    return Room.all if term.blank?

    Room.where("conditions LIKE ?", "%#{term}%")
  end

  def owner?(usr)
    user == usr
  end

  def member?(user)
    members.include?(user)
  end

  def limited?
    people_limit <= members.count
  end

  def over?
    people_limit < members.count
  end

  def limited_validation
    errors.add(:people_limit, "is too many") if over?
  end
end
