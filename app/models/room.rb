class Room < ApplicationRecord
  has_many :memberships, class_name: "Member", foreign_key: "room_id", dependent: :destroy
  has_many :members, through: :memberships, source: :user
  belongs_to :user

  validates :date, presence: true
  validates :shop_name, presence: true

  def self.search(term = "")
    return Room.all if term.blank?

    Room.where("conditions LIKE ?", "%#{term}%")
  end

  def owner?(user)
    self.user == user
  end
end
