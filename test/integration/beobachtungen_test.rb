require 'test_helper'

class BeobachtungenTest < ActionDispatch::IntegrationTest
  
  include Capybara::DSL

  test "erstelle und editiere beobachtung as subscriber" do
    capybara_login_subscriber_sebi
    visit '/'
    assert page.has_content?("sebi")
    
    #Beobachtung anlegen
    click_link "Beobachtung melden"
    fill_in 'Fahrtrichtung des Transports', :with => 'Norden1'
    fill_in 'Ortsname', :with => 'Enschede'
    check 'beobachtung_kennzeichen_radioaktiv'
    fill_in 'Ankunftszeit', :with => '30.10.2015 22:31'
    fill_in 'Obere Nummer (Gefahrennummer)', :with => '78'
    click_button 'Beobachtung erstellen'
    
    assert page.has_content?("Beobachtung wurde angelegt.")
    assert page.has_content?("Beobachtung aus Enschede")
    assert !page.has_content?("Löschen")
    assert page.has_content? "Foto hochladen"
    assert page.has_content? "Quelle: sebi"
    assert page.has_content? "Kennzeichnung"
    assert page.has_content? "Bearbeiten"
    assert page.has_content? "Startseite"
    
    # Foto hochladen
    click_link "Foto hochladen"
    assert page.has_content?('Hier können sie noch ein Bild dazu hochladen.')
    page.attach_file('upload_foto', "#{Rails.root}/test/fixtures/files/schweich.jpg")
    click_button "Foto hochladen"
    
    assert page.has_content?("Foto zur Beobachtung hochgeladen. Danke.")
    assert page.has_content?("Beobachtung aus Enschede")
    assert page.has_content?("Foto ändern")
    assert_equal 2, all('img').count

    # Container nachtragen
    click_link "Bearbeiten"
    fill_in 'Beschreibung der Container/Ladung', :with => "Alle Container waren grün und hässlich."
    fill_in 'Anzahl der Container', :with => 5
    fill_in 'Transportfirma', :with => "Kieserling"
    click_button "Beobachtung aktualisieren"
    assert page.has_content?("Beobachtung wurde aktualisiert.")
    assert page.has_content?("Beobachtung aus Enschede")
    assert !page.has_content?("Löschen")
    assert page.has_content? "Anzahl der Container: 5"
    assert page.has_content?("Foto ändern")
    assert page.has_content? "Bearbeiten"
    assert page.has_content? "Firma: Kieserling"
  end 
  
  #TODO ab hier
  test "ordne Beobachtung existenten Transportabschnitt zu" do 
    # Anmeldung als Admin
    # Beobachtung abrufen, Anzeige prüfen
    # Toleranztage erhöhen
    # Transportabschnitt zuordnen
  end
  
  test "lege neuen Abschnitt an beim zuordnen" do 
  
  end 
  
  test "lege neuen Transport an beim zuordnen" do
  
  end
  
  test "loesche Beobachtung" do 
  
  end 
  
end
