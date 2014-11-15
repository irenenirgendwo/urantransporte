require 'test_helper'

class StoffeControllerTest < ActionController::TestCase
  
  setup do
    @stoff = stoffe(:one)
    login_admin_anna
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stoffe)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stoff" do
    assert_difference('Stoff.count') do
      post :create, stoff: { beschreibung: @stoff.beschreibung, bezeichnung: "Neuer Stoff", gefahr_nummer: "78", un_nummer: "2978" }
    end

    assert_redirected_to stoff_path(assigns(:stoff))
  end

  test "should show stoff" do
    get :show, id: @stoff
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stoff
    assert_response :success
  end

  test "should update stoff" do
    patch :update, id: @stoff, stoff: { beschreibung: @stoff.beschreibung, bezeichnung: @stoff.bezeichnung, gefahr_nummer: @stoff.gefahr_nummer, un_nummer: @stoff.un_nummer }
    #assert_redirected_to stoff_path(assigns(:stoff))
  end

  test "should destroy stoff" do
    assert_difference('Stoff.count', -1) do
      delete :destroy, id: @stoff
    end

    assert_redirected_to stoffe_path
  end
end
