class Notification < ApplicationRecord
  belongs_to :notify_to, class_name: "User", foreign_key: :to
  belongs_to :notifyed_by, class_name: "User", foreign_key: :by

  validates :to, presence: true, numericality: { only_integer: true }
  validates :by, presence: true, numericality: { only_integer: true }
  validates :action, presence: true
  # 通知を受け取るユーザーと通知の対象の部屋の所持者は一致する
  validate :room_owner_and_notify_to_are_the_same

  ACTIONS = %w[join bookmark]
  # actionはACTIONSの中のいずれかでなければならない
  validate :action_must_be_one_of_actions, if: -> { action.present? }

  def room
    Room.find_by(id: room_id)
  end

  def room_owner_and_notify_to_are_the_same
    return unless room_id || Room.find_by(id: room_id)

    room.owner.id == to ? return : errors.add(:room_id, "must be the id of the room owned by the user who received the notification")
  end

  def action_must_be_one_of_actions
    errors.add(:action, "must be one of the value (join bookmark)") if ACTIONS.select { |e| e.eql?(action) }.blank?
  end
end
