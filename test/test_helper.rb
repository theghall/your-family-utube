ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def get_profile_id(name)
    Profile.find_by(name: name).id
  end
  
  def num_approved_videos(profile)
    profile.videos.where(approved: true).count
  end
  
    def num_unapproved_videos(profile)
    profile.videos.where(approved: false).count
  end
end
