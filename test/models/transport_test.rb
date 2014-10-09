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
    assert_equal 1, @transport_russ_lingen_1.transportabschnitte.size
    assert_equal 1, @transport_russ_lingen_2.transportabschnitte.size

    assert @transport_russ_lingen_1.add(@transport_russ_lingen_2)
    
    # Nicht vorhande Transportdaten hinzugefuegt?
    assert @transport_russ_lingen_1.behaelter, "Behaelter sollte hinzugefuegt werden"
    assert_equal stoff1, @transport_russ_lingen_1.stoff, "Stoff ist geblieben #{@transport_russ_lingen_1.attributes}"
    
    # Transportabschnitte auch alle zusammen gefuegt
    assert_equal 2, @transport_russ_lingen_1.transportabschnitte.size
    
    assert @transport_russ_lingen_1.save, "#{@transport_russ_lingen_1.errors.full_messages}"
    assert Transport.find(3).behaelter, "Behaelter sollte hinzugefuegt werden"
  end

end
