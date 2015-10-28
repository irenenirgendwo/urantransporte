require 'test_helper'

class OrtTest < ActiveSupport::TestCase
  
  test "create ort by koordinates" do 
    ort = Ort.create_by_koordinates("52.040103", "9.117370")
    assert_not_nil ort
    assert_equal "Barntrup", ort.name
    assert_equal 52.040103, ort.lat
    assert_equal "Bielefeld", Ort.create_by_koordinates("52.008696", "8.548576").to_s
    assert_equal "Brokdorf", Ort.create_by_koordinates(53.86312, 9.32437).to_s
  end 
  
  test "lege passende orte zu namen an" do 
    orte = Ort.lege_passende_orte_an("Neustadt")
    assert 4 <= orte.size
    orte.each do |ort|
      assert_match /Neustadt/, ort.name
      assert_not_nil ort.lat
    end
    
    orte = Ort.lege_passende_orte_an("Brokdorf")
    assert_equal 1, orte.size
    orte.each do |ort|
      #puts "#{ort.lat}, #{ort.lon}"
      assert_match /Brokdorf/, ort.name
      assert_not_nil ort.lat
    end
  end
  
  test "find or create ort" do
    ort = Ort.find_or_create_ort("Hamburg")
    assert_equal 3, ort.id, "Ort sollte gefunden sein"
    ort = Ort.find_or_create_ort("Aserbaidschan")
    assert 5 < ort.id, "Ort noch nicht vorhanden, neu angelegt"
  end 
  
  
  test "ort waehlen" do 
    # Orte vorhanden
    eindeutig, ort_e = Ort.ort_waehlen("Gronau")
    assert eindeutig
    assert 52.21254, ort_e.lat
    # Orte nicht vorhanden
    eindeutig, ort_e = Ort.ort_waehlen("Neustadt")
    assert_not eindeutig
    assert 3 < ort_e.size unless ort_e.nil?
    eindeutig, ort_e = Ort.ort_waehlen("Kiel")
    assert eindeutig, "#{ort_e}"
    assert ort_e.kind_of? Ort
  end
  
  test "bereinige ungenutzte orte" do
    assert_equal 1, Ort.loesche_ungenutzte
  end
  
  test "objekte zum ort finden" do 
    ort = Ort.find(1)
    ort2 = Ort.find(2)
    ort3 = Ort.find(3)
    assert_equal 1, ort.objekte_mit_ort_id.size, "#{ort.objekte_mit_ort_id}"
    assert_equal 2, ort2.objekte_mit_ort_id.size, "#{ort2.objekte_mit_ort_id}" 
    assert_equal 2, ort3.beobachtungen.size
    assert_equal 1, ort3.umschlaege.size
    assert_equal 3, ort3.objekte_mit_ort_id.size, "#{ort3.objekte_mit_ort_id}" 
  end 
  
  test "ort zu anderem zusammen fuehren" do 
    ort = Ort.find(1)
    ort2 = Ort.find(2)
    ort3 = Ort.find(3)
    assert_equal 1, ort.objekte_mit_ort_id.size, "#{ort.objekte_mit_ort_id}"
    assert_equal 2, ort2.objekte_mit_ort_id.size, "#{ort2.objekte_mit_ort_id}" 
    assert_equal 3, ort3.objekte_mit_ort_id.size, "#{ort3.objekte_mit_ort_id}" 
    assert ort.add_ort(ort2), "#{ort.add_ort(ort2)} hat noch #{ort2.objekte_mit_ort_id}"
    #caching aufheben
    assert 3, ort.anlagen(true).size
    assert_equal 3, ort.objekte_mit_ort_id.size, "#{ort.objekte_mit_ort_id} \nORT 2 #{ort2.objekte_mit_ort_id}"
  end 
  
  test "get routen" do
    gronau = Ort.find(1)
    routen = gronau.get_routen
    assert_equal 1, routen.size
    assert_equal 1, routen.first.id
  end 
  
end
