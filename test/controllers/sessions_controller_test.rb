require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  test "login admin has worked" do 
    login_admin_anna
    assert_not_nil current_user
    assert logged_in?
    assert_equal "admin", current_user.role, "#{current_user.role}"
    assert is_admin?
  end
  
  
  test "should get new" do
    login_admin_anna
    get :new
    assert_response :success
  end
  
  test "login emil" do 
    login_editor_emil
    assert logged_in?
  end 

end
