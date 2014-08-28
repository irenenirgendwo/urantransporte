require 'test_helper'

class BeobachtungenControllerTest < ActionController::TestCase
  setup do
    @beobachtung = beobachtungen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beobachtungen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beobachtung" do
    assert_difference('Beobachtung.count') do
      post :create, beobachtung: { beschreibung: @beobachtung.beschreibung }
    end

    assert_redirected_to beobachtung_path(assigns(:beobachtung))
  end

  test "should show beobachtung" do
    get :show, id: @beobachtung
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beobachtung
    assert_response :success
  end

  test "should update beobachtung" do
    patch :update, id: @beobachtung, beobachtung: { beschreibung: @beobachtung.beschreibung }
    assert_redirected_to beobachtung_path(assigns(:beobachtung))
  end

  test "should destroy beobachtung" do
    assert_difference('Beobachtung.count', -1) do
      delete :destroy, id: @beobachtung
    end

    assert_redirected_to beobachtungen_path
  end
end
