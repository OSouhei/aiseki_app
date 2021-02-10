class HomeController < ApplicationController
  def index
    @rooms = if user_signed_in?
               current_user.joining.all
             else
               Room.take(6)
             end
  end
end
