class Room < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :shop_name, presence: true
end
