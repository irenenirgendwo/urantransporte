require 'test_helper'

class TransporteControllerTest < ActionController::TestCase
  setup do
    login_admin_anna
    @transport = transporte(:one)
    @stoff = stoffe(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transport" do
    assert_equal Anlage.find(1), @transport.start_anlage
    assert_difference('Transport.count') do
      post :create, transport: { start_anlage_id: 1, datum: Date.new(2014,3,12),
                                stoff_id: 1, ziel_anlage_id: 2 }
    end

    assert_redirected_to transport_path(assigns(:transport))
  end

  test "should show transport" do
    get :show, id: @transport
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transport
    assert_response :success
  end

  test "should update transport" do
    patch :update, id: @transport, transport:  { behaelter: @transport.behaelter, menge_netto: @transport.menge_netto, 
                                start_anlage: @transport.start_anlage, datum: @transport.datum,
                                stoff_id: @stoff.id, ziel_anlage: @transport.ziel_anlage }
    assert_redirected_to transport_path(assigns(:transport))
  end

  test "should destroy transport" do
    assert_difference('Transport.count', -1) do
      delete :destroy, id: @transport
    end

    assert_redirected_to transporte_path
  end
end
