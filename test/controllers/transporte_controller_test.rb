require 'test_helper'

class TransporteControllerTest < ActionController::TestCase
  setup do
    @transport = transporte(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transporte)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transport" do
    assert_equal Anlage.find(1), @transport.start_anlage
    assert_difference('Transport.count') do
      post :create, transport: { start_anlage_id: 1, datum: Date.new(2014,3,12),
                                stoff: "Uranhexafluorid", ziel_anlage_id: 2 }
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
    patch :update, id: @transport, transport:  { behaelter: @transport.behaelter, menge: @transport.menge, 
                                start_anlage: @transport.start_anlage, datum: @transport.datum,
                                stoff: @transport.stoff, ziel_anlage: @transport.ziel_anlage }
    assert_redirected_to transport_path(assigns(:transport))
  end

  test "should destroy transport" do
    assert_difference('Transport.count', -1) do
      delete :destroy, id: @transport
    end

    assert_redirected_to transporte_path
  end
end
