require 'test_helper'

class FirmenControllerTest < ActionController::TestCase
  setup do
    login_admin_anna
    @firma = firmen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:firmen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create firma" do
    assert_difference('Firma.count') do
      post :create, firma: { beschreibung: @firma.beschreibung, name: "Neue Firma"}
    end

    assert_redirected_to firma_path(assigns(:firma))
  end

  test "should show firma" do
    get :show, id: @firma
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @firma
    assert_response :success
  end

  test "should update firma" do
    patch :update, id: @firma, firma: { beschreibung: "Neue Beschreibung", name: @firma.name}
    assert_redirected_to firma_path(assigns(:firma))
  end

  test "should destroy firma" do
    # nicht referenzierte Firma darf zerstoert werden
    assert_difference('Firma.count', -1) do
      delete :destroy, id: 6
    end

    assert_redirected_to firmen_path
  end
end
