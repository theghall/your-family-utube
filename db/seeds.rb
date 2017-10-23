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

video = profile.videos.build(youtube_id: 'https://www.youtube.com/watch?v=aCbfMkh940Q', approved: false, tag_list: 'movie clip, alien, weaver')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/VIliZvuvirs', approved: false, tag_list: 'movie clip, top gun, cruise')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/fXW02XmBGQw', approved: false, tag_list: 'movie clip, goldeneye, bond')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/-1F7vaNP9w0', approved: false, tag_list: 'movie clip, war games, broderick')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/vJ7603kiQcY', approved: false, tag_list: 'snl, simmer down')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/4jF40yfgoEA', approved: false, tag_list: 'trip, sons, mower')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/uMqpb7SMlZo', approved: false, tag_list: 'nate, sons, bouncer')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/7fLatvRidbw', approved: false, tag_list: 'movie clip, kellys heros, sutherland')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/Z3sLhnDJJn0', approved: false, tag_list: 'princess bride`')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/SKRma7PDW10', approved: false, tag_list: 'mongo, blazing saddles')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/X_gwnFSFzv0', approved: true, tag_list: 'movie clip, spock, star trek')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/jDBPmEAheCY', approved: true, tag_list: 'movie clip, lord of the rings')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/bgLfOrVJJMg', approved: true, tag_list: 'movie clip, kirk, shatner, star trek')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/b47TY5VbFHY', approved: true, tag_list: 'movie clip, star wars, solo, ford')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/hamBT5gz-Lk', approved: true, tag_list: 'galactica, original')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/A-b_Rjf_urs', approved: true, tag_list: 'chimes')
video.save!
video = profile.videos.build(youtube_id: 'https://youtu.be/q-BRee2bAho', approved: true, tag_list: 'rush, peart, drum solo')
video.save!
video = profile.videos.build(youtube_id: 'https://www.youtube.com/watch?v=SjbPi00k_ME', approved: true, tag_list: 'movie clip, casablanca')
video.save!
video = profile.videos.build(youtube_id: 'https://www.youtube.com/watch?v=vtSmfws0_To', approved: true, tag_list: 'movie clip, casablanca')
video.save!

user = User.new(name: "Donald Duck",
             email: "donald@email.com",
             password: "foobar",
             password_confirmation: "foobar",
             pin: "1234",
             pin_confirmation: "1234")
user.skip_confirmation!
user.save!

profile = user.profiles.build(name: "Goofy")
profile.save!

video = profile.videos.build(youtube_id: 'https://www.youtube.com/watch?v=iSyfpUyzQGU', approved: true, tag_list: 'warp')
video.save!
