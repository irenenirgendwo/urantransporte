require 'test_helper'

class BeobachtungenTest < ActionDispatch::IntegrationTest
  
  include Capybara::DSL
  include SessionsHelper
  
  # Das automatische zurueck setzten funktioniert nicht richtig
  setup do 
    beob = Beobachtung.find(1)
    beob.transportabschnitt= nil
    beob.save
  end 

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
    assert page.has_no_content?("Löschen")
    assert page.has_content? "Anzahl der Container: 5"
    assert page.has_content?("Foto ändern")
    assert page.has_content? "Bearbeiten"
    assert page.has_content? "Firma: Kieserling"
  end 
  
  #TODO ab hier
  test "schaue Beobachtungen an" do 
    # Anmeldung als Editor Emil
    capybara_login_editor_emil
    assert page.has_content? "Emil"
    assert page.has_no_content?("Anmelden")
    assert page.has_content?("E-Mail: emil@nirgendwo.info")
    assert page.has_content?("Daten")
    click_link "Atomtransport-Datenbank"
    #click_link "Daten"
    # No Javascript allowed, also funktioniert Navigieren ueber die Leiste nicht :(
    visit '/transporte'
    assert page.has_content?("Zeitfenster-Auswahl")
    
    visit '/beobachtungen'
    assert page.has_content?("Beobachtungen")
    assert page.has_content?("Neue Beobachtung")
    assert page.has_content?("Anzeigen")
    assert page.has_content?("Angezeigt werden zunächst die neuen Beobachtungen,")
    assert_equal 3, find('table').all('tr').count
    click_link "Alle"
    assert page.has_content?("Beobachtungen")
    assert_equal 4, find('table').all('tr').count
    click_link "Zugeordnete"
    assert_equal 1, find('tbody').all('tr').count
  
    # Beobachtung abrufen, Anzeige prüfen
    find('tbody').find('tr').find('a', match: :first).click
    assert page.has_content?("Beobachtung aus Kiel")
    assert page.has_content?("Eckdaten")
    assert page.has_content?("Quelle: Formular")
    assert page.has_content?("Verkehrsträger: Schiff")
    assert page.has_content?("Beschreibung")
    assert page.has_content?("Foto hochladen")
    assert page.has_content?("Beschreibung")
    assert page.has_content?("Zuordnung zu einem Transport(abschnitt)")
    assert page.has_content?("Die Beobachtung wurde bei dem folgenden Transport gemacht.")
    assert page.has_content?("Transport anzeigen")
    assert page.has_content?("Transportabschnitt")
    assert page.has_content?("Datum: 05.07.2012")
    assert page.has_content?("Schiffstransport von St. Petersburg nach Hamburg")
    assert page.has_content?("Beobachtungen: Kiel,")
    
    click_link "Transport anzeigen"
    assert page.has_content?("Transportdaten")
    assert page.has_content?("05.07.2012 von Ruslland nach ANF")
    assert page.has_content?("Rahmendaten")
    assert page.has_content?("Transportverlauf")
    assert page.has_content?("Schiffstransport")
    assert page.has_content?("Umschlag in Hamburg")
    assert page.has_content?("Transport mit unbekanntem Verkehrsträger von Hamburg nach Lingen (05.07.2012 – 05.07.2012)")
    assert page.find('#map')
    # ginge nur mit Javascript
    #assert_equal 4, page.find('#map').find('.leaflet-marker-pane').all('img').count
    
    click_link "Kiel"
    assert page.has_content?("Beobachtung aus Kiel")
  end
  
  
  # Voraussetzung: vorheriger Test tut
  #
  test "ordne Beobachtung existenten Transportabschnitt zu" do 
    capybara_login_editor_emil
    visit '/beobachtungen'
    find('tbody').find('tr', match: :first).find('a', match: :first).click
    # Auf Beobachtungsseite - richtige checken
    assert page.has_content?("Beobachtung aus Hamburg")
    assert page.has_content?("Verkehrsträger: LKW")
    assert page.has_content?("Mögliche Transportabschnitte:")
    assert page.has_content?("Mögliche Transporte")
    
    assert_equal 1, find('#beobachtung_transportabschnitt_table').find('tbody').all('tr').count
    assert_equal 2, find('#beobachtung_transporte_table').find('tbody').all('tr').count
    
    click_link "Zuordnen"
    assert page.has_content?("Transportabschnitt wurde erfolgreich zugeordnet.")
    assert page.has_content?("Beobachtung aus Hamburg")
    assert page.has_content?("Verkehrsträger: LKW")
    assert page.has_no_content?("Mögliche Transportabschnitte:")
    assert page.has_no_content?("Mögliche Transporte")
    # Transportabschnitt zuordnen
    assert page.has_content?("Die Beobachtung wurde bei dem folgenden Transport gemacht.")
    assert page.has_content?("Transport anzeigen")
    assert page.has_content?("Transportabschnitt")
    assert page.has_content?("Datum: 05.07.2012")
    assert page.has_content?("von Hamburg nach Lingen")
    assert page.has_content?("Beobachtungen: Hamburg")
    
    # Transportzuordnung wieder loeschen
  end
  
  test "lege neuen Abschnitt an beim zuordnen" do 
    capybara_login_editor_emil
    visit '/beobachtungen'
    find('tbody').find('tr', match: :first).find('a', match: :first).click
    # Auf Beobachtungsseite - richtige checken
    assert page.has_content?("Beobachtung aus Hamburg")
    assert page.has_content?("Verkehrsträger: LKW")
    assert page.has_content?("Mögliche Transportabschnitte:")
    assert page.has_content?("Mögliche Transporte")
    
    assert_equal 1, find('#beobachtung_transportabschnitt_table').find('tbody').all('tr').count
    assert_equal 2, find('#beobachtung_transporte_table').find('tbody').all('tr').count
    
    
  end 
  
  test "lege neuen Transport an beim zuordnen" do
  
  end
  
  test "loesche Beobachtung" do 
  
  end 
  
end
