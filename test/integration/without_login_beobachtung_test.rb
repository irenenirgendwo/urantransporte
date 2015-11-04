require 'test_helper'

class WithoutLoginBeobachtungTest < ActionDispatch::IntegrationTest

  include Capybara::DSL

  test "Startseite" do
    get "/"
    assert_response :success
    assert_select 'table', 1
    assert_select 'nav', 1
    assert_select 'tr', 4
  end
  
  test "Beobachtung melden ohne Foto" do 
    get "/beobachtungen/new"
    assert_response :success 
    assert_select '#mapedit', 1, "Ortsformular"
    assert_select '.panel', 7
    
    ## with Capybara, kommentiert fürs Nachmachen
    
    # Den Link besuchen
    visit '/'
    # Überprüfen ob ein bestimmter Inhalt / Text auf der Seite ist
    assert page.has_content?("Beobachtung melden")
    # Einen Link anklicken, gegeben werden muss der angezeigte Text des Links
    click_link "Beobachtung melden"
    assert page.has_content?("Beobachtung melden")
    assert page.has_content?("Richtung und Zeit")
    assert page.has_content?("Standort eintragen")
    
    ## Ohne eingegebene Daten funktioneirt das nicht
    # Button anklicken (manchmal sehen Links auch aus wie Buttons, im Zweifelsfall beides ausprobieren)
    click_button "Beobachtung erstellen"
    assert page.has_content?("Beobachtung melden")
    assert page.has_content?("muss ausgefüllt werden") || page.has_content?('Bitte einen Ort eingeben über die Karte oder das Namensfeld.')

    ## Dateneingabe und Beobachtungerstellung ohne Foto
    # Die id des html-input-Elements, das ausgefüllt werden soll und dann ein Hash :with => dem Wert, der da rein soll
    fill_in 'Fahrtrichtung des Transports', :with => 'Norden1'
    fill_in 'Ortsname', :with => 'Münster'
    # Checkbox anhaken, wieder wird hier die id des input-Elements gebraucht,
    # herauzubekommen über Firefox, auf die Seite gehen und Inspect Element / Untersuche Element
    check 'beobachtung_kennzeichen_radioaktiv'
    check 'beobachtung_polizei'
    click_button 'Beobachtung erstellen'
    
    # Jetzt fehlt noch die Ankunftszeit
    assert page.has_content?("muss ausgefüllt werden")
    fill_in 'Ankunftszeit', :with => '30.10.2015 22:31'
    click_button 'Beobachtung erstellen'

    assert page.has_content?('Beobachtung wurde angelegt.')
    assert page.has_content?('Vielen Dank für die Eingabe ihrer Beobachtung.')
    assert !page.has_content?("Foto hochladen") # muss falsch sein, has_content richtig?
    
    ## Angelegte Beobachtung pruefen
    beob = Beobachtung.find_by(fahrtrichtung: 'Norden1')
    # prüft ob Wert (Beobachtung) nicht nil ist
    assert_not_nil beob
    # Radioaktiv muss gesetzt sein, ätzend nicht (! ist Verneinung)
    assert beob.kennzeichen_radioaktiv
    assert !beob.kennzeichen_aetzend
    assert !beob.foto
    # assert_equal prüft auf Gleichheit
    assert_equal "Formular", beob.quelle
    # assert prüft immer, ob der Wert zu etwas, was als true verstanden wird ausgewertet wird
    assert beob.polizei
    
    # Neue Beobachtung, diesmal mit Foto
    click_link "Neue Beobachtung"
    assert page.has_content?("Beobachtung melden")
    assert page.has_content?("Richtung und Zeit")
    assert page.has_content?("Standort eintragen")
  end
  
  test "Beobachtung mit Foto" do 
    visit '/'
    click_link "Beobachtung melden"
    assert page.has_content?("Beobachtung melden")
    assert page.has_content?("Richtung und Zeit")
    assert page.has_content?("Standort eintragen")
    assert page.has_content?("Foto")

    fill_in 'Fahrtrichtung des Transports', :with => 'Norden2'
    fill_in 'Ankunftszeit', :with => '30.10.2015 22:31'
    fill_in 'ortname', :with => 'Gronau'
    check 'beobachtung_kennzeichen_radioaktiv'
    check 'beobachtung_kennzeichen_aetzend'
    check 'beobachtung_foto'
    click_button "Beobachtung erstellen"
    
    #Angelegte Beobachtung pruefen
    beob = Beobachtung.find_by(fahrtrichtung: 'Norden2')
    assert_not_nil beob
    assert beob.kennzeichen_aetzend
    assert !beob.kennzeichen_spaltbar
    assert beob.foto, "#{beob.attributes}"
    
    # Foto-Hochladeseite
    assert page.has_content?('Beobachtung wurde angelegt.')
    assert page.has_content?('Vielen Dank für die Eingabe ihrer Beobachtung.')
    assert page.has_content?('Hier können sie noch ein Bild dazu hochladen.')

    #test_file  = File.new("#{Rails.root}/test/fixtures/files/schweich.jpg","r")
    page.attach_file('upload_foto', "#{Rails.root}/test/fixtures/files/schweich.jpg")
    #attach_file "upload_foto", "#{Rails.root}/test/fixtures/files/schweich.jpg"
    fill_in "Urheber*in", :with => "Pay Numrich"
    
    click_button "Foto hochladen"
    
    assert page.has_content?('Foto zur Beobachtung hochgeladen. Danke.')
    assert page.has_content?('Vielen Dank für die Eingabe ihrer Beobachtung.')
    assert page.has_content?("Neue Beobachtung")
  end
  
end
