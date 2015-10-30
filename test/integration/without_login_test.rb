require 'test_helper'

class WithoutLoginTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  test "Startseite" do
    get "/"
    assert_response :success
    assert_select 'table', 1
    assert_select 'nav', 1
    assert_select 'tr', 4
  end
  
  test "Beobachtung melden" do 
    get "/beobachtungen/new"
    assert_response :success 
    assert_select '#mapedit', 1, "Ortsformular"
    assert_select '.panel', 7
    
    # with Capybara
    visit '/'
    assert page.has_content?("Beobachtung melden")
    click_link "Beobachtung melden"
    assert page.has_content?("Beobachtung melden")
    assert page.has_content?("Richtung und Zeit")
    assert page.has_content?("Standort eintragen")
    
    # Ohne eingegebene Daten funktioneirt das nicht
    click_button "Beobachtung erstellen"
    assert page.has_content?("Beobachtung melden")
    assert page.has_content?("muss ausgefüllt werden")

    # Dateneingabe und Beobachtungerstellung ohne Foto
    fill_in 'Fahrtrichtung des Transports', :with => 'Norden'
    fill_in 'Ankunftszeit', :with => '30.10.2015 22:31'
    fill_in 'Ortsname', :with => 'Münster'
    check 'beobachtung_kennzeichen_radioaktiv'
    click_button 'Beobachtung erstellen'
    assert page.has_content?('Beobachtung wurde angelegt.')
    assert page.has_content?('Vielen Dank für die Eingabe ihrer Beobachtung.')
    
    # Neue Beobachtung, diesmal mit Foto
    click_link "Neue Beobachtung"
    assert page.has_content?("Beobachtung melden")
    assert page.has_content?("Richtung und Zeit")
    assert page.has_content?("Standort eintragen")
    #assert !page.has_content?("Foto hochladen") # muss falsch sein, has_content richtig?
    
    fill_in 'Fahrtrichtung des Transports', :with => 'Norden'
    fill_in 'Ankunftszeit', :with => '30.10.2015 22:31'
    check 'beobachtung_kennzeichen_radioaktiv'
    check("beobachtung_foto")
    click_button "Beobachtung erstellen"

    # Foto-Hochladeseite
    assert page.has_content?('Beobachtung wurde angelegt.')
    assert page.has_content?('Vielen Dank für die Eingabe ihrer Beobachtung.')
    assert page.has_content?("Foto hochladen")

    attach_file "upload_foto", "/public/fotos/castor.jpg"
    fill_in "Urheber*in", "Pay Numrich"
    click_button "Foto hochladen"
    
    assert page.has_content?('Foto zur Beobachtung hochgeladen. Danke.'
    # Am Ende auf der Beobachtungsseite oder Danke seite landen???
  end
  
  test "Transporte abfragen" do 
   
  end 
  
end
