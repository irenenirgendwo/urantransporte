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
    assert_equal 6, orte.size
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
  
  test "ort waehlen" do 
    # Orte nicht vorhanden
    eindeutig, ort_e = Ort.ort_waehlen("Neustadt")
    assert_not eindeutig
    assert_equal 6, ort_e.size
    eindeutig, ort_e = Ort.ort_waehlen("Kiel")
    assert eindeutig
    assert ort_e.kind_of? Ort
    # Orte vorhanden
    eindeutig, ort_e = Ort.ort_waehlen("Gronau")
    assert eindeutig
    assert 52.21254, ort_e.lat
  end
  
  
end
