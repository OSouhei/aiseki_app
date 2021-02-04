class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :joining_rooms, class_name: "Member", foreign_key: "user_id", dependent: :destroy
  has_many :joining, through: :joining_rooms, source: :room
  has_many :passive_notifications, class_name: "Notification", foreign_key: :to, dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: :by, dependent: :destroy
  # passive_notifications と同じ
  has_many :notifications, foreign_key: :to, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :booked_rooms, through: :bookmarks, source: :room

  mount_uploader :profile_image, ProfileImageUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }

  def join(room)
    return false if room.nil? || room.limited?

    joining << room
    active_notifications.create(to: room.owner.id, room_id: room.id) # 通知を作成
  rescue ActiveRecord::RecordInvalid # 部屋の作成者と参加者が同じ場合
    false
  end

  def exit(room)
    room.member?(self) ? joining.delete(room) : false
  end

  def book(room)
    booked_rooms << room
  end

  def unbook(room)
    booked_rooms.delete room
  end
end
