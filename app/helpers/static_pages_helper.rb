module StaticPagesHelper
    def get_video_url(video) 
        "https://www.youtube.com/embed/" + video.youtube_id + "?rel=0"
    end
end
