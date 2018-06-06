ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    fixtures :all

    # Returns true if a test user is logged in.
    def is_logged_in?
      session[:user_id].present?
    end
  end
end
