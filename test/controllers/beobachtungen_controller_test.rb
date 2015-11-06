require 'test_helper'

class BeobachtungenControllerTest < ActionController::TestCase
  setup do
    login_admin_anna
    @beobachtung = beobachtungen(:zug)
    @beobachtung_lkw = beobachtungen(:lkw)
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
    # Ohne Zeit geht nichts
    assert_no_difference('Beobachtung.count') do
      post :create, beobachtung: { ort: @beobachtung.ort }
    end
    # Ohne Ort auch nicht
    assert_no_difference('Beobachtung.count') do
      post :create, beobachtung: { ankunft_zeit: @beobachtung.abfahrt_zeit }
    end
    # So muss es gehen
    assert_difference('Beobachtung.count') do
      post :create, beobachtung: { ort_id: @beobachtung.ort.id, ankunft_zeit: @beobachtung.ankunft_zeit }, ort: "Lingen"
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
    patch :update, id: @beobachtung, beobachtung: { beschreibung: @beobachtung.beschreibung, foto: true }
    assert_response :success
    
    patch :update, id: @beobachtung, beobachtung: { beschreibung: @beobachtung.beschreibung }
    assert_response :success
  end
  
  test "should update foto" do 
    test_file = fixture_file_upload('files/schweich.jpg','application/jpg')
    patch :update_foto, id: @beobachtung.id, upload_foto: test_file, foto_recht: "Pay" 
    neue_beobachtung = Beobachtung.find(1)
    assert_equal "Pay", neue_beobachtung.foto_recht, "#{neue_beobachtung}"
    assert_not_nil neue_beobachtung.foto_path
    assert_response :redirect
    assert_redirected_to @beobachtung
  end 

  test "should destroy beobachtung" do
    assert_difference('Beobachtung.count', -1) do
      delete :destroy, id: @beobachtung
    end

    assert_redirected_to beobachtungen_path
  end
end
