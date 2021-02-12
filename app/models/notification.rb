class Notification < ApplicationRecord
  belongs_to :notify_to, class_name: "User", foreign_key: :to
  belongs_to :notifyed_by, class_name: "User", foreign_key: :by

  validates :to, presence: true, numericality: { only_integer: true }
  validates :by, presence: true, numericality: { only_integer: true }
  validates :action, presence: true

  ACTIONS = %w[join bookmark follow]
  # actionはACTIONSの中のいずれかでなければならない
  validate :action_must_be_one_of_actions, if: -> { action.present? }

  default_scope -> { order(created_at: :desc) }

  def action_must_be_one_of_actions
    errors.add(:action, "must be one of the value (join bookmark)") if ACTIONS.select { |e| e.eql?(action) }.blank?
  end

  def room
    Room.find_by(id: room_id)
  end
end
