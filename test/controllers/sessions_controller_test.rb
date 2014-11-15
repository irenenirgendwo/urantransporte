require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  setup do
    login_admin_anna
  end
  
  test "login admin has worked" do 
    assert_not_nil current_user
    assert logged_in?
    assert_equal "admin", current_user.role, "#{current_user.role}"
    assert is_admin?
  end
  
  
  test "should get new" do
    get :new
    assert_response :success
  end

end
