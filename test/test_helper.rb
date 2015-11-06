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
  
  def login_editor_emil
    emil = User.create(name: "Emil", password: "foobar1", role: 1, email: "emil@nirgendwo.info")
    user = User.find_by(name: "Emil")
    log_in(user)
  end 
  
  def capybara_login_subscriber_sebi
    visit "/"
    capybara_abmelden
    click_link "Registrieren"
    fill_in 'user_name', :with => "sebi"
    fill_in 'user_email', :with => "sebi@nirgendwo.info"
    fill_in 'user_password', :with => "usersc4t"
    fill_in 'user_password_confirmation', :with => "usersc4t"
    click_button "Registrieren"
  end 
  
  def capybara_login_editor_emil
    emil = User.create(name: "Emil", password: "foobar1", role: 1, email: "emil@nirgendwo.info")
    visit "/"
    capybara_abmelden
    click_link "Anmelden"
    fill_in "E-Mail", :with => "emil@nirgendwo.info"
    fill_in "Passwort", :with => "foobar1"
    find('form').find_button("Anmelden").click
  end 
  
  def capybara_abmelden
    unless page.has_content? "Anmelden"
      find('#user_menu').click
      click_link("Abmelden")
    end
  end
  
end
