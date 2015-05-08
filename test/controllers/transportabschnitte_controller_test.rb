require 'test_helper'

class TransportabschnitteControllerTest < ActionController::TestCase
  setup do
    login_admin_anna
    @transportabschnitt = transportabschnitte(:petersburg_hamburg)
    @transport_anderer = transporte(:one)
  end

  test "should get new" do
    get :new, transport_id: 2
    assert_response :success
  end

  test "should create transportabschnitt" do
    assert_difference('Transportabschnitt.count') do
      post :create, transportabschnitt: { transport_id: 1, start_ort: "Hamburg", 
                            end_ort: "Schweiz" }
    end

    assert_redirected_to transportabschnitt_path(assigns(:transportabschnitt))
  end

  test "should get edit" do
    get :edit, id: @transportabschnitt
    assert_response :success
  end

  test "should update transportabschnitt" do
    patch :update, id: transportabschnitte(:to_delete), transportabschnitt: { transport_id: 1, start_ort: "Hamburg", 
                            end_ort: "Schweiz" }
    assert_redirected_to Transport.find(1)
  end

  test "should destroy transportabschnitt" do
    transport = @transportabschnitt.transport
    assert_difference('Transportabschnitt.count', -1) do
      delete :destroy, id: @transportabschnitt
    end

    assert_redirected_to transport
  end
end
