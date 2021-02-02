module UsersHelper
  def profile_image_url(user)
    user.profile_image.url || "/uploads/user/profile_image/default_icon.jpg"
  end
end
