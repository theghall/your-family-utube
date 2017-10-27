module ApplicationHelper
  def app_name
    "Your Family UTube"
  end

  def support_email
    "vastdawnsoftware@gmail.com"
  end

  def full_title(page_title = '')
    base_title = app_name
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def parent_user
    redirect_to root_url unless parent_mode?
  end

  def video_count_display
    video_count = current_user.videos.count

    if AccountType.has_limit(current_user.account_type_id)
      max_videos = AccountType.limit(current_user.account_type_id).to_s
      display = "#{video_count}/#{max_videos}"
    else
      display = "#{video_count}"
    end

  end
end
