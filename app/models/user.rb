class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :joining_rooms, class_name: "Member", foreign_key: "user_id", dependent: :destroy
  has_many :joining, through: :joining_rooms, source: :room

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }

  def join(room)
    joining << room
  rescue ActiveRecord::RecordInvalid # 部屋の作成者と参加者が同じ場合
    false
  end
end
