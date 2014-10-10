require 'test_helper'

class AbfragenControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select ".panel", count:5
  end

  test "should get show" do
    post :show, {:start_datum => "1999-01-01", :end_datum =>"2000-01-01" }
    assert_response :success
    assert_select "table", count: 0
    
    post :show, {:start_datum => "2000-01-01", :end_datum =>"2012-12-01" }
    assert_response :success
    assert_select "table", count: 1
    assert_select "table tr", count: 4 # "Sollten 3 Transporte gefunden werden plus Kopfzeile"
    
    post :show, {:start_datum => "2000-01-01", :end_datum =>"2011-12-01" }
    assert_response :success
    assert_select "table", count: 1
    assert_select "table tr", count: 2 # "Sollten 1 Transporte gefunden werden"
  end

  test "should get calendar" do
    get :calendar, {:start_datum => "1999-01-01", :end_datum =>"2000-01-01" }
    assert_response :success
  end

end
