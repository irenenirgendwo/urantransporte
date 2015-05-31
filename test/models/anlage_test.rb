require 'test_helper'

class AnlageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "anlagen vorhanden" do 
    assert_equal "Urenco", Anlage.find(1).name
  end

  test "get anlagen for selection field" do 
    anlagen = Anlage.get_anlagen_for_selection_field
    assert_equal 4, anlagen.size
    assert_equal 1, anlagen["Urenco"]
  end 
  
  test "update verbunde abschnitte" do 
    anf = Anlage.find(2)
    assert_equal 2, anf.ort.id
    han = Ort.new(name: "Hannover")
    ort_alt = anf.ort
    # Anlage auf neuen Ort setzen
    assert han.save
    id = han.id
    anf.ort = han
    anf.save
    # Transportabschnitte umsetzen
    assert 2, ort_alt.ziel_transportabschnitte.size
    assert anf.update_verbundene_transportabschnitte(2)
    # Endort-Id von entsprechendem Transportabschnitt muss sich geandert haben
    transport = Transport.find(3)
    abschnitt = transport.transportabschnitte.find_by(firma_id: 1)
    assert_not_nil abschnitt
    assert_equal id, abschnitt.end_ort_id
    
  end

end
