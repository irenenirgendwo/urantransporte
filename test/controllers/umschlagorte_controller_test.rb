require 'test_helper'

class UmschlagorteControllerTest < ActionController::TestCase
  setup do
    @umschlagort = umschlagorte(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:umschlagorte)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create umschlagort" do
    assert_difference('Umschlagort.count') do
      post :create, umschlagort: { ortsname: @umschlagort.ortsname }
    end

    assert_redirected_to umschlagort_path(assigns(:umschlagort))
  end

  test "should show umschlagort" do
    get :show, id: @umschlagort
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @umschlagort
    assert_response :success
  end

  test "should update umschlagort" do
    patch :update, id: @umschlagort, umschlagort: { ortsname: @umschlagort.ortsname }
    assert_redirected_to umschlagort_path(assigns(:umschlagort))
  end

  test "should destroy umschlagort" do
    assert_difference('Umschlagort.count', -1) do
      delete :destroy, id: @umschlagort
    end

    assert_redirected_to umschlagorte_path
  end
end
