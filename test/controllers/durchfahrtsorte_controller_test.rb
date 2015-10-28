require 'test_helper'

class DurchfahrtsorteControllerTest < ActionController::TestCase
  setup do
    @durchfahrtsort = durchfahrtsorte(:one)
    @gronau = orte(:gronau)
    @ort = orte(:hamburg)
    @route1 = routen(:one)
  end

 
  test "should get new" do
    get :new, route: @route1.id
    assert_response :success
  end

  test "should create durchfahrtsort" do
    assert_equal 1, @gronau.id
    assert_equal 1, @route1.id
    assert_difference('Durchfahrtsort.count') do
      post :create, durchfahrtsort: { reihung: 3, route_id: @route1.id }, ortname: "Hamburg"
    end
    assert_redirected_to @route1
    
    
    assert_difference('Durchfahrtsort.count') do
      post :create, durchfahrtsort: { reihung: 1, route_id: 2 }, ortname: "Hamburg"
    end
    assert_redirected_to routen(:two)
    
    # ORt schon vorhanden 
    assert_no_difference('Durchfahrtsort.count') do
      post :create, durchfahrtsort: { reihung: 1, route_id: 1 }, ortname: "Gronau"
    end
    assert_redirected_to new_durchfahrtsort_path
  end


  test "should destroy durchfahrtsort" do
    assert_difference('Durchfahrtsort.count', -1) do
      delete :destroy, id: @durchfahrtsort
    end

    assert_redirected_to @route1
  end
end
