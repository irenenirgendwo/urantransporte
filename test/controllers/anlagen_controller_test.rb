# encoding: utf-8
require 'test_helper'

class AnlagenControllerTest < ActionController::TestCase
  setup do
    login_admin_anna
    @anlage = anlagen(:urenco)
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

  test "should create anlage mit Ortsnamen" do
    # Zweite Anlage an existierendem Ort
    assert_difference('Anlage.count') do
      post :create, anlage: { beschreibung: "AKW", 
                            name: "AKW Lingen", plz: "59051" }, ortname: "Lingen",
                    redirect_params: anlagen_path
    end
    anlage = Anlage.find_by(name: "AKW Lingen")
    assert_not_nil anlage
    assert_not_nil anlage.ort
    #puts anlage.ort.attributes 
    assert_equal 2, anlage.ort.id #Lingen als Ort gefunden
    assert_redirected_to anlagen_path
    
    # Anlage an einem neuen Ort mit eindeutigem Namen
    assert_difference('Anlage.count') do
      post :create, anlage: { beschreibung: "AKW", name: "AKW Brokdorf" }, ortname: "Brokdorf"
    end
    # TODO: was tun, wenn Brokdorf nicht gefunden wird?
    anlage = Anlage.find_by(name: "AKW Brokdorf")
    assert_not_nil anlage
    assert_not_nil anlage.ort
    assert_equal "Brokdorf", anlage.ort.name
    assert_redirected_to anlage
    
    # Anlage an neuem Ort mit mehrdeutigem Namen
    assert_difference('Anlage.count') do
      post :create, anlage: { ort: "Neustadt", beschreibung: "ba", name: "AKW Neustadt" },
                    redirect_params: anlagen_path
    end
    eindeutig, ort_e =  Ort.ort_waehlen("Neustadt")
    assert_not eindeutig
    assert_response :redirect
    assert_match /orte\/ortswahl/, @response.redirect_url
    anlage = Anlage.find_by(name: "AKW Neustadt")
    assert_not_nil anlage
    assert_nil anlage.ort
  end
  
  # Macht Ortseingabe nur über Lat/Lon-Parameter
  #
  test "should create anlage with lat and lon parameters" do
    assert_difference('Anlage.count') do
      post :create, anlage: { name: "AKW Brokdorf", beschreibung: "AKW"} , lat: 53.86312, lon: 9.32437 ,
                    redirect_params: anlagen_path
    end
    anlage = Anlage.find_by(name: "AKW Brokdorf")
    assert_not_nil anlage
    assert_not_nil anlage.ort
    #puts anlage.ort.attributes 
    assert_equal 53.86312, anlage.ort.lat 
    assert_equal "Brokdorf", anlage.ort.name 
    assert_redirected_to anlagen_path
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
    patch :update, id: @anlage, anlage: { beschreibung: "Urenco ist doof", name: @anlage.name}
    assert_redirected_to @anlage
  end

  test "should destroy anlage" do
    # Unmögliche Löschung
    assert_equal 4, Anlage.count
    delete :destroy, id: @anlage
    assert_equal 4, Anlage.count, "Anlage darf nicht gelöscht werden weil Transporte vorhanden"
    # mögliche Löschung
    assert_difference('Anlage.count', -1) do
      delete :destroy, id: 4
    end

    assert_redirected_to anlagen_path
  end
  
end
