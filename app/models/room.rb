class Room < ApplicationRecord
  has_many :members, class_name: "Member", foreign_key: "room_id", dependent: :destroy
  belongs_to :user

  validates :date, presence: true
  validates :shop_name, presence: true
end
