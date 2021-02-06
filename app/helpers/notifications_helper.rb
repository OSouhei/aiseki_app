module NotificationsHelper
  def notification_message(notification)
    by = notification.notifyed_by
    room = Room.find_by(id: notification.room_id)
    {
      user: link_to(by.name, user_path(by), class: "text-dark"),
      action: "#{notification.action}ed",
      room: link_to("your room", room_path(room), class: "text-dark")
    }
  end
end
