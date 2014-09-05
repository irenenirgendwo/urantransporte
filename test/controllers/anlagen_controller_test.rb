require 'test_helper'

class AnlagenControllerTest < ActionController::TestCase
  setup do
    @anlage = anlagen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:anlagen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create anlage" do
    assert_difference('Anlage.count') do
      post :create, anlage: { adresse: @anlage.adresse, beschreibung: @anlage.beschreibung, 
                            name: @anlage.name, ort: @anlage.ort, plz: @anlage.plz },
                    redirect_params: anlage_path(@anlage)
    end

    #assert_redirected_to anlage_path(assigns(:anlage))
  end

  test "should show anlage" do
    get :show, id: @anlage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @anlage
    assert_response :success
  end

  test "should update anlage" do
    patch :update, id: @anlage, anlage: { adresse: @anlage.adresse, beschreibung: @anlage.beschreibung, name: @anlage.name, ort: @anlage.ort, plz: @anlage.plz }
    assert_redirected_to anlage_path(assigns(:anlage))
  end

  test "should destroy anlage" do
    assert_difference('Anlage.count', -1) do
      delete :destroy, id: @anlage
    end

    assert_redirected_to anlagen_path
  end
end
