ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"

# Advanced reports
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(:color => true)]

# Webmock
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup some fixtures in test/fixtures/*.yml for all tests
  fixtures :pages
end

# Load all stubs for HTTP requests
require 'stubbing_helper'