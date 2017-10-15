# update_yt_titles
#
require 'active_record'


videos = Video.where(title: nil)

videos.each do |v|
  utube_video = Yt::Video.new(id: v.youtube_id)

  v.update_attribute(:title, utube_video.title)
end
