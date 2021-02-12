class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: :index
  after_action :make_notifications_checked, only: :index

  def index
    @notifications = current_user.notifications
  end

  private

  # 通知をチェック済みにする
  def make_notifications_checked
    @notifications.each do |notification|
      notification.update(checked: true)
    end
  end
end
