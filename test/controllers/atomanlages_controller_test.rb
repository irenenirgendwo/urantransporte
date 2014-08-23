require 'test_helper'

class AtomanlagesControllerTest < ActionController::TestCase
  setup do
    @atomanlage = atomanlages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:atomanlages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create atomanlage" do
    assert_difference('Atomanlage.count') do
      post :create, atomanlage: { description: @atomanlage.description, name: @atomanlage.name, ort: @atomanlage.ort }
    end

    assert_redirected_to atomanlage_path(assigns(:atomanlage))
  end

  test "should show atomanlage" do
    get :show, id: @atomanlage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @atomanlage
    assert_response :success
  end

  test "should update atomanlage" do
    patch :update, id: @atomanlage, atomanlage: { description: @atomanlage.description, name: @atomanlage.name, ort: @atomanlage.ort }
    assert_redirected_to atomanlage_path(assigns(:atomanlage))
  end

  test "should destroy atomanlage" do
    assert_difference('Atomanlage.count', -1) do
      delete :destroy, id: @atomanlage
    end

    assert_redirected_to atomanlages_path
  end
end
