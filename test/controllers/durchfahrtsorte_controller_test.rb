require 'test_helper'

class DurchfahrtsorteControllerTest < ActionController::TestCase
  setup do
    @durchfahrtsort = durchfahrtsorte(:one)
    @ort = orte(:gronau)
    @route1 = routen(:one)
  end

 
  test "should get new" do
    get :new, route: @route1.id
    assert_response :success
  end

  test "should create durchfahrtsort" do
    assert_equal 1, @ort.id
    assert_equal 1, @route1.id
    assert_difference('Durchfahrtsort.count') do
      post :create, durchfahrtsort: { index: 3, ort_id: @ort.id, route_id: @route1.id }
    end

    assert_redirected_to routen_path(assigns(:durchfahrtsort))
    
    
    assert_difference('Durchfahrtsort.count') do
      post :create, durchfahrtsort: { index: 1, ort_id: @ort.id, route_id: 2 }
    end
    assert_redirected_to routen_path(assigns(:durchfahrtsort))
    
    post :create, durchfahrtsort: { index: 1, ort_id: @ort.id, route_id: 1 }
    # ORt schon vorhanden 
    assert_redirected_to new_durchfahrtsort_path
  end


  test "should destroy durchfahrtsort" do
    assert_difference('Durchfahrtsort.count', -1) do
      delete :destroy, id: @durchfahrtsort
    end

    assert_redirected_to routen_path
  end
end
