require 'test_helper'

class RouteTest < ActiveSupport::TestCase

  setup do 
    @route = routen(:one)
    @gronau = durchfahrtsorte(:one)
    @lingen = durchfahrtsorte(:two)
  end 
  
  test "schiebe ort hoch" do 
    assert_equal 2, @lingen.reihung
    assert @route.schiebe_hoch(@lingen), "#{@lingen.attributes}"
    assert_equal 1, @lingen.reihung
  end 
  
  test "schiebe ort hoch erfolglos" do 
    assert !@route.schiebe_hoch(@gronau)
    assert_equal 1, @gronau.reihung
  end 
  
  test "include ort" do 
    assert @route.includes_ort?(orte(:gronau).id)
    assert @route.includes_ort?(2)
    assert !@route.includes_ort?(orte(:hamburg).id)
    assert @route.includes_ort?(orte(:kiel).id)
  end 
  
  test "zuordnung" do
    route = routen(:route_zugeordnet)
    assert !route.transportabschnitte.empty?
  end 
  
end
