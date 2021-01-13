module ApplicationHelper
  def full_title(page_title = "")
    base_title = "相席app"
    if page_title.blank?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def replace_flash_class(flash_class)
    return unless flash_class.is_a?(String)

    replacement = {
      notice: "alert alert-success",
      alert: "alert alert-warning",
      error: "alert alert-danger"
    }
    replacement[flash_class.intern]
  end
end
