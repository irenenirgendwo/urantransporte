require 'test_helper'

class RoutenTest < ActionDispatch::IntegrationTest
  
  include Capybara::DSL
  
  test "Routen anschauen" do
    visit '/routen'
    assert page.has_content?("Alle angelegten Transport-Routen")
    assert page.has_content?("Unbekannt")
    assert_equal 3, find('table').find('tbody').all('tr').count
    assert_equal 4, find('table').find('thead').all('th').count
    # Unbekannt anschauen
    find('table').find('tbody').all('tr')[1].find('a').click
    assert page.has_content?("Route: Unbekannt")
    assert page.has_content?("Zu dieser Pseudo-Route dürfen keine Durchfahrtsorte angelegt werden.")
    click_link("Alle Routen")
    assert page.has_content?("Alle angelegten Transport-Routen")
    # Route1 anschauen
    find('table').find('tbody').all('tr')[0].find('a').click
    assert page.has_content?("Route: Route1")
    assert_equal 3, find('#durchfahrtsorte_table').find('tbody').all('tr').count
    assert page.has_content?("Transporte")
    assert page.has_content?("Karte")
    assert page.has_content?("Keine Transporte gefunden")
  end
  
  test "Nicht zugeordnete Route editieren" do 
    capybara_login_editor_emil
    visit '/routen'
    find('table').find('tbody').all('tr')[0].all('a')[0].click
    assert page.has_content?("Route: Route1")
    assert_equal 3, find('#durchfahrtsorte_table').find('tbody').all('tr').count

    # Mit dem mittleren ist alles erlaubt, oben und unten nur loeschen und hoch bzw. runterschieben
    assert_equal 2, find('#durchfahrtsorte_table').find('tbody').all('tr')[0].all('td')[2].all('a').size
    assert_equal 3, find('#durchfahrtsorte_table').find('tbody').all('tr')[1].all('td')[2].all('a').size
    assert_equal 2, find('#durchfahrtsorte_table').find('tbody').all('tr')[2].all('td')[2].all('a').size
    
    # tausche letzte beiden orte
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[2].has_content? "Kiel"
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[1].has_content? "Lingen"
    find('#durchfahrtsorte_table').find('tbody').all('tr')[2].all('td')[2].all('a')[0].click
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[2].has_content? "Lingen"
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[1].has_content? "Kiel"
    
    #Füge neuen Ort hinzu
    click_link("Neuer Durchfahrtsort")
    assert page.has_content?("Neuen Durchfahrtsort erstellen")
    click_link("Abbrechen")
    click_link("Neuer Durchfahrtsort")
    assert page.has_content?("Neuen Durchfahrtsort erstellen")
    
    fill_in 'Ortsname', :with => "Trier"
    click_button "Durchfahrtsort erstellen"
    assert page.has_content?("Route: Route1")
    assert page.has_content?("Durchfahrtsort erfolgreich angelegt.")
    assert_equal 4, find('#durchfahrtsorte_table').find('tbody').all('tr').count
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[3].has_content? "Trier"
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[3].has_content? "4"
    
    # und ersten Ort löschen geht leider nicht ohne javascript wegen confirm
  end 
  
  test "zugeordnete Route editieren" do 
    capybara_login_editor_emil
    visit '/routen'
    find('table').find('tbody').all('tr')[2].find('a', match: :first).click
    assert page.has_content?("Route: Zugeordnet")
    assert_equal 3, find('#durchfahrtsorte_table').find('tbody').all('tr').count

    # Mit dem mittleren ist alles erlaubt, oben und unten nur loeschen und hoch bzw. runterschieben
    assert_equal 0, find('#durchfahrtsorte_table').find('tbody').all('tr')[0].all('td')[2].all('a').size
    assert_equal 1, find('#durchfahrtsorte_table').find('tbody').all('tr')[1].all('td')[2].all('a').size
    assert_equal 0, find('#durchfahrtsorte_table').find('tbody').all('tr')[2].all('td')[2].all('a').size
    
    #Füge neuen Ort hinzu
    click_link("Neuer Durchfahrtsort")
    assert page.has_content?("Neuen Durchfahrtsort erstellen")
    
    fill_in 'Ortsname', :with => "Brunsbüttel"
    fill_in 'Index zum Einfügen', :with => 2
    click_button "Durchfahrtsort erstellen"
    assert page.has_content?("Route: Zugeordnet")
    assert page.has_content?("Durchfahrtsort erfolgreich angelegt.")
    assert_equal 4, find('#durchfahrtsorte_table').find('tbody').all('tr').count
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[1].has_content? "Brunsbüttel"
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[1].has_content? "2"
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[3].has_content? "4"
    
    # Mit dem mittleren ist alles erlaubt, oben und unten nur loeschen und hoch bzw. runterschieben
    assert_equal 0, find('#durchfahrtsorte_table').find('tbody').all('tr')[0].all('td')[2].all('a').size
    assert_equal 2, find('#durchfahrtsorte_table').find('tbody').all('tr')[1].all('td')[2].all('a').size
    assert_equal 2, find('#durchfahrtsorte_table').find('tbody').all('tr')[2].all('td')[2].all('a').size
    assert_equal 0, find('#durchfahrtsorte_table').find('tbody').all('tr')[3].all('td')[2].all('a').size
    
    # tausche mittlere orte
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[2].has_content? "Kiel"
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[1].has_content? "Brunsbüttel"
    find('#durchfahrtsorte_table').find('tbody').all('tr')[2].all('td')[2].all('a')[0].click
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[2].has_content? "Brunsbüttel"
    assert find('#durchfahrtsorte_table').find('tbody').all('tr')[1].has_content? "Kiel"
  end 
  
  
  
end
