require 'test_helper'

class UmschlaegeControllerTest < ActionController::TestCase
  setup do
    @umschlag = umschlaege(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:umschlaege)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create umschlag" do
    assert_difference('Umschlag.count') do
      post :create, umschlag: {  }
    end

    assert_redirected_to umschlag_path(assigns(:umschlag))
  end

  test "should show umschlag" do
    get :show, id: @umschlag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @umschlag
    assert_response :success
  end

  test "should update umschlag" do
    patch :update, id: @umschlag, umschlag: {  }
    assert_redirected_to umschlag_path(assigns(:umschlag))
  end

  test "should destroy umschlag" do
    assert_difference('Umschlag.count', -1) do
      delete :destroy, id: @umschlag
    end

    assert_redirected_to umschlaege_path
  end
end
