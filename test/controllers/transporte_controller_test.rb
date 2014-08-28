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
    assert_difference('Transport.count') do
      post :create, transport: { behaeltertyp: @transport.behaeltertyp, menge: @transport.menge, start: @transport.start, stoff: @transport.stoff, ziel: @transport.ziel }
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
    patch :update, id: @transport, transport: { behaeltertyp: @transport.behaeltertyp, menge: @transport.menge, start: @transport.start, stoff: @transport.stoff, ziel: @transport.ziel }
    assert_redirected_to transport_path(assigns(:transport))
  end

  test "should destroy transport" do
    assert_difference('Transport.count', -1) do
      delete :destroy, id: @transport
    end

    assert_redirected_to transporte_path
  end
end
