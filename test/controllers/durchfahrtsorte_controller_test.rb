require 'test_helper'

class DurchfahrtsorteControllerTest < ActionController::TestCase
  setup do
    @durchfahrtsort = durchfahrtsorte(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:durchfahrtsorte)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create durchfahrtsort" do
    assert_difference('Durchfahrtsort.count') do
      post :create, durchfahrtsort: { index: @durchfahrtsort.index }
    end

    assert_redirected_to durchfahrtsort_path(assigns(:durchfahrtsort))
  end

  test "should show durchfahrtsort" do
    get :show, id: @durchfahrtsort
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @durchfahrtsort
    assert_response :success
  end

  test "should update durchfahrtsort" do
    patch :update, id: @durchfahrtsort, durchfahrtsort: { index: @durchfahrtsort.index }
    assert_redirected_to durchfahrtsort_path(assigns(:durchfahrtsort))
  end

  test "should destroy durchfahrtsort" do
    assert_difference('Durchfahrtsort.count', -1) do
      delete :destroy, id: @durchfahrtsort
    end

    assert_redirected_to durchfahrtsorte_path
  end
end
