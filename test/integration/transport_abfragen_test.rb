require 'test_helper'

class TransportAbfragenTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  test "transportabfrage nach umkreis" do 
    visit '/'
    # Prüfe Abfrage-Formular
    click_link 'Transporte-Abfrage'
    assert page.has_content?("Transport-Abfragen")
    assert page.has_content?("Zeitfenster-Auswahl")
    assert page.has_content?("Durchfahrtsort-Auswahl")
    assert page.has_content?("Verkehrsträger")
    assert page.has_content?("Start-Anlage ")
    assert page.has_content?("Ziel-Anlage ")
    assert page.has_content?("Stoff ")
    assert page.has_content? "Uranhexafluorid"
    
    # Ausfüllen und Abschicken
    fill_in 'dort', :with => 'Hamburg'
    fill_in 'radius', :with => '300'
    click_button "Passende Transporte anzeigen"
    
    assert page.has_content? "Ausgewählte Transporte"
    assert page.has_content? 'Keine Transporte gefunden.'
    
    # Oh es fehlt noch die Zeitangabe anzupassen, also zurück und Zeit eingeben...
    # Es gibt kein Zurück-Button ist mir dabei aufgefallen.
  end 
  
  test "transportabfrage nach anlagen" do 
  
  end
  
  test "transportabfrage nach stoff mit kalenderdarstellung" do 
  
  end 
  
end
