require 'test_helper'

class UserRegistrationAndSettingsTest < ActionDispatch::IntegrationTest
 
  include Capybara::DSL

  test "Startseite" do
    get "/"
    assert_response :success
    assert_select 'table', 1
    assert_select 'nav', 1
    assert_select 'tr', 5
  end
  
  test "Login nicht registriert" do
    get "/"
    assert_response :success 

    visit "/"
    assert page.has_content?("Atomtransport gesehen?")
    assert page.has_content?("Anmelden")
    click_link "Anmelden"

    assert page.has_content?("E-Mail")
    fill_in 'session_email', :with => "user@testworld.com"
    fill_in 'session_password', :with => "usersc4t"
    click_button "Anmelden"
    assert page.has_content?("Falscher Benutzername oder Passwort.")
    assert page.has_content?("Jetzt registrieren!")
    click_link "Jetzt registrieren!"

    assert page.has_content?("Name")
    assert page.has_content?("Passwort-Bestätigung")
  end
  
  test "Registrieren, anmelden, Passwort ändern, abmelden" do
    get "/"
    assert_response :success

    visit "/"
    assert page.has_content?("Registrieren")
    click_link "Registrieren"

    assert page.has_content?("Name")
    assert page.has_content?("Passwort-Bestätigung")

    click_button "Registrieren"

    assert page.has_content?("Name muss ausgefüllt werden")
    assert page.has_content?("Email muss ausgefüllt werden")
    assert page.has_content?("Password muss ausgefüllt werden")

    fill_in 'user_name', :with => "Test User"
    fill_in 'user_email', :with => "user@testworld,com"
    fill_in 'user_password', :with => "user"
    fill_in 'user_password_confirmation', :with => "usersc4t"
    click_button "Registrieren"

    assert page.has_content?("Email ist nicht gültig")
    assert page.has_content?("Password confirmation stimmt nicht mit Password überein")
    assert page.has_content?("Password ist zu kurz (weniger als 6 Zeichen)")

    fill_in 'user_email', :with => "user@testworld.com"
    fill_in 'user_password', :with => "usersc4t"
    fill_in 'user_password_confirmation', :with => "usersc4t"
    click_button "Registrieren"

    assert page.has_content?("Test User")

    #DB überprüfen
    u = User.find_by(name: "Test User")
    assert_not_nil u
    assert_equal u.email, "user@testworld.com"
    assert_equal u.role, "subscriber"

    click_button "Test User"
    click_link "Profil"

    assert page.has_content?("E-Mail: user@testworld.com")

    click_button "Test User"
    click_link "Einstellungen"

    assert page.has_content?("Passwort")
    fill_in 'user_password', :with => "123dtrn"
    fill_in 'user_password_confirmation', :with => "123nrtd"
    click_button "Änderungen speichern"

    assert page.has_content?("Password confirmation stimmt nicht mit Password überein")
    fill_in 'user_password', :with => "123dtrn"
    fill_in 'user_password_confirmation', :with => "123dtrn"
    click_button "Änderungen speichern"
    
    assert page.has_content?("Einstellungen gespeichert")

    click_button "Test User"
    click_link "Abmelden"

    assert page.has_content?("Atomtransport gesehen?")
    assert page.has_content?("Anmelden")
    click_link "Anmelden"

    assert page.has_content?("E-Mail")
    fill_in 'session_email', :with => "user@testworld.com"
    fill_in 'session_password', :with => "usersc4t"
    click_button "Anmelden"

    assert page.has_content?("Falscher Benutzername oder Passwort.")
    assert page.has_content?("E-Mail")
    fill_in 'session_email', :with => "user@testworld.com"
    fill_in 'session_password', :with => "123dtrn"
    click_button "Anmelden"

    assert page.has_content?("E-Mail: user@testworld.com")

    click_button "Test User"
    click_link "Einstellungen"

    assert page.has_content?("Benutzerkonto löschen")
    click_link "Löschen"
   # click_link "Abbrechen"  #Bestätigung scheint Capybara automatisch zu geben. Interessant, aber an dieser Stelle ja nicht störend.
  #  assert page.has_content?("Benutzerkonto löschen")
  #  click_link "Löschen"
  #  click_button "OK"
    
    assert page.has_content?("Atomtransport gesehen?")

    #DB überprüfen
    u = User.find_by(name: "Test User")
    assert_nil u

  end
    
end
