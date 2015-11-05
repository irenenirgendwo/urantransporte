ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  include SessionsHelper

  # Add more helper methods to be used by all tests here...
  
  def login_admin_anna
    user = User.find_by(name: "Anna")
    log_in(user)
  end 
  
  def capybara_login_subscriber_sebi
    visit "/"
    click_link "Registrieren"
    fill_in 'user_name', :with => "sebi"
    fill_in 'user_email', :with => "sebi@nirgendwo.info"
    fill_in 'user_password', :with => "usersc4t"
    fill_in 'user_password_confirmation', :with => "usersc4t"
    click_button "Registrieren"
  end 
  
end
