class HomeController < ApplicationController
  def index
    @rooms = Room.take 6
  end
end
