require 'test_helper'

class TransportTest < ActiveSupport::TestCase
  
  setup do
    @transport = transporte(:one)
    @transport_russ_lingen_1 = transporte(:petersburg_lingen1)
    @transport_russ_lingen_2 = transporte(:petersburg_lingen2)
  end

  test "anlage zu transport vorhanden" do 
    assert_equal "Urenco", @transport.start_anlage.name
    false_transport = Transport.new(:start_anlage => Anlage.find(1), :datum => "2012-04-03" )
    assert !false_transport.save, "Transport darf ohne Zielanlage nicht gespeichert werden"
  end

  test "add another transport" do 
    # Vorherige Daten
    stoff1 = @transport_russ_lingen_1.stoff
    assert_nil @transport_russ_lingen_1.behaelter
    assert_equal 2, @transport_russ_lingen_1.transportabschnitte.size
    assert_equal 1, @transport_russ_lingen_2.transportabschnitte.size

    assert @transport_russ_lingen_1.add(@transport_russ_lingen_2)
    
    # Nicht vorhande Transportdaten hinzugefuegt?
    assert @transport_russ_lingen_1.behaelter, "Behaelter sollte hinzugefuegt werden"
    assert_equal stoff1, @transport_russ_lingen_1.stoff, "Stoff ist geblieben #{@transport_russ_lingen_1.attributes}"
    
    # Transportabschnitte auch alle zusammen gefuegt
    assert_equal 3, @transport_russ_lingen_1.transportabschnitte.size
    
    assert @transport_russ_lingen_1.save, "#{@transport_russ_lingen_1.errors.full_messages}"
    assert Transport.find(3).behaelter, "Behaelter sollte hinzugefuegt werden"
  end
  
  test "sort abschnitte and umschlaege" do 
    sorted_abschnitte = @transport_russ_lingen_1.sort_abschnitte_and_umschlaege
    assert_equal 3, sorted_abschnitte.size, "2 Abshnitte, 1 Umschlag"
    assert_equal 1, @transport.sort_abschnitte_and_umschlaege.size, "2 Abshnitte, 1 Umschlag"
  end
  
  test "calculate start and end datum" do 
    abschnitt_umschlag_list = @transport_russ_lingen_1.sort_abschnitte_and_umschlaege
    start_datum, end_datum = @transport_russ_lingen_1.get_start_and_end_datum abschnitt_umschlag_list
    assert_equal Date.new(2012,7,1), start_datum
    assert_equal Date.new(2012,7,5), end_datum
    abschnitt_umschlag_list = @transport.sort_abschnitte_and_umschlaege
    start_datum, end_datum = @transport.get_start_and_end_datum abschnitt_umschlag_list
    assert_equal Date.new(2013,9,1), start_datum
    assert_equal Date.new(2013,9,1), end_datum
  end
  
  test "get umschlaege" do 
    date = Date.new(2012,7,4)
    assert_not_nil @transport_russ_lingen_1.get_umschlag(date)
    #assert_equal "Hamburg", @transport_russ_lingen_1.get_umschlag(date).ort.to_s
    assert_nil @transport_russ_lingen_1.get_umschlag(Date.new(2012,7,1))
  end

end
