require 'test_helper'

class OrteControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  
  test "bereinige ungenutzte orte" do
    post :bereinige
    assert_redirected_to orte_path  
  end
end
