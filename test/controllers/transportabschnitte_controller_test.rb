require 'test_helper'

class TransportabschnitteControllerTest < ActionController::TestCase
  setup do
    @transportabschnitt = transportabschnitte(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transportabschnitte)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transportabschnitt" do
    assert_difference('Transportabschnitt.count') do
      post :create, transportabschnitt: {  }
    end

    assert_redirected_to transportabschnitt_path(assigns(:transportabschnitt))
  end

  test "should show transportabschnitt" do
    get :show, id: @transportabschnitt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transportabschnitt
    assert_response :success
  end

  test "should update transportabschnitt" do
    patch :update, id: @transportabschnitt, transportabschnitt: {  }
    assert_redirected_to transportabschnitt_path(assigns(:transportabschnitt))
  end

  test "should destroy transportabschnitt" do
    assert_difference('Transportabschnitt.count', -1) do
      delete :destroy, id: @transportabschnitt
    end

    assert_redirected_to transportabschnitte_path
  end
end
