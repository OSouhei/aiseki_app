class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true, numericality: { only_integer: true }, uniqueness: { scope: :room_id }
  validates :room_id, presence: true, numericality: { only_integer: true }
end
