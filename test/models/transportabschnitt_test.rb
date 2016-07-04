require 'test_helper'

class TransportabschnittTest < ActiveSupport::TestCase
  
  setup do
    @transport = transporte(:one)
    @transport_russ_lingen_1 = transporte(:petersburg_lingen1)
    @transport_russ_lingen_2 = transporte(:petersburg_lingen2)
    @abschnitt = transportabschnitte(:hamburg_lingen_1)
    @beobachtung = beobachtungen(:lkw)
  end
  
  test "get transporte around" do
    transportabschnitte = Transportabschnitt.get_abschnitte_from_time(@beobachtung.ankunft_zeit)
    assert_not transportabschnitte.empty?
    assert_equal 1, transportabschnitte.size
  end 
  
end
