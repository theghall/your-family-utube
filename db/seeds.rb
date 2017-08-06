user = User.new(name: "Gary Hall",
             email: "gary@email.com",
             password: "foobar",
             password_confirmation: "foobar",
             pin: "1234",
             pin_confirmation: "1234")
user.skip_confirmation!
user.save!

