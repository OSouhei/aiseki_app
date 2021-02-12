module NotificationsHelper
  def notification_message(notification)
    user = notification.notifyed_by
    action = notification.action
    case action
    when "join"
      "#{user.name}があなたの部屋に参加しました。"
    when "bookmark"
      "#{user.name}があなたのルームをブックマークしました。"
    when "follow"
      "#{user.name}にフォローされました。"
    end
  end
end
