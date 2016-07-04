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
    fill_in 'dort', :with => 'München'
    fill_in 'radius', :with => '100'
    click_button "Passende Transporte anzeigen"
    
    assert page.has_content? "Ausgewählte Transporte"
    assert page.has_content? 'Keine Transporte gefunden.'
    
    # Oh es fehlt noch die Zeitangabe anzupassen, also zurück und Zeit eingeben...
    click_button "Zurück zur Auswahl"
    assert page.has_content? "Transport-Abfragen"
    assert_equal "100", page.find('#radius').value  # Auswahlspeicherung
    assert_equal "München", page.find('#dort').value  # Auswahlspeicherung
    fill_in 'dort', :with => 'Hamburg'
    fill_in "start_datum", :with => "01.01.2012"
    fill_in "end_datum", :with => "01.10.2013"
    click_button "Passende Transporte anzeigen"
    
    assert page.has_content? "Ausgewählte Transporte"
    assert page.has_no_content? 'Keine Transporte gefunden.'
    assert find('.transport-tabelle')
    assert_equal 3, find('.transport-tabelle').find('tbody').all('tr').count # Genau drei Transporte

  end 
  
  test "transportabfrage nach anlagen" do 
    visit '/'
    click_link 'Transporte-Abfrage'
    fill_in "start_datum", :with => "01.01.2011"
    fill_in "end_datum", :with => "31.12.2015"
    assert_equal 4, find('#Ziel_').all('option').size 
    # TODO
    #select(1, :from => '#Ziel_')
    #click_button "Passende Transporte anzeigen"
    #assert page.has_content? "Ausgewählte Transporte"
    #assert page.has_content? 'Keine Transporte gefunden.'
    
    #click_button "Zurück zur Auswahl"
    #deselect('1', :from => "#Ziel_")
    #click_button "Passende Transporte anzeigen"
    #assert page.has_content? "Ausgewählte Transporte"
    #assert_equal 5, find('.transport-tabelle').find('tbody').all('tr').count # Genau drei Transporte


  end
  
  test "transportabfrage nach stoff mit kalenderdarstellung" do 
    visit '/'
    click_link 'Transporte-Abfrage'
    fill_in "start_datum", :with => "01.01.2011"
    fill_in "end_datum", :with => "31.12.2015"
    check 'Uranhexafluorid'
    click_button "Passende Transporte anzeigen"
    
    assert page.has_content? "Ausgewählte Transporte"
    assert page.has_no_content? 'Keine Transporte gefunden.'
    assert find('.transport-tabelle')
    assert_equal 2, find('table').find('tbody').all('tr').count 
    
    click_button "Kalender"
    assert page.has_content? "Ausgewählte Transporte"
    assert page.has_content? "2011"
    assert page.has_content? "2012"
    assert page.has_content? "2013"
    assert find('.calendar-body')
    assert_equal 5, find('.calendar-body').all('.calendar_transportabschnitt').size
    
    click_button "Zurück zur Auswahl"
    uncheck 'Uranhexafluorid'
    check 'Uranoxid'
    click_button "Passende Transporte anzeigen"
    
    assert page.has_content? "Ausgewählte Transporte"
    assert page.has_no_content? 'Keine Transporte gefunden.'
    assert find('.transport-tabelle')
    assert_equal 3, find('table').find('tbody').all('tr').count 
  end 
  
end
