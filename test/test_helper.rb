ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveRecord::FixtureSet
    class << self
      alias :orig_create_fixtures :create_fixtures
    end

    def self.create_fixtures f_dir, fs_names, *args
      # Make sure user and profiles are loaded first
      fs_names = %w(account_types users profiles settings) & fs_names | fs_names
      orig_create_fixtures f_dir, fs_names, *args
    end
end

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
