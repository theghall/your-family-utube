user = User.new(name: "Gary Hall",
             email: "gary@email.com",
             password: "foobar",
             password_confirmation: "foobar",
             pin: "1234",
             pin_confirmation: "1234")
user.skip_confirmation!
user.save!

profile = user.profiles.build(name: "Pod")
profile.save!

video = profile.videos.build(youtube_id: "aCbfMkh940Q", approved: true)
video.save!

tag = Tag.new(name: "Clip")
tag.save!

video.video_tags.build(tag_id: tag.id).save!

user = User.new(name: "Jerry Hall",
             email: "jerry@email.com",
             password: "foobar",
             password_confirmation: "foobar",
             pin: "1234",
             pin_confirmation: "1234")
user.skip_confirmation!
user.save!



