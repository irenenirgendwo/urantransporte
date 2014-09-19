require 'test_helper'

class AnlageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "anlagen vorhanden" do 
    assert_equal "Urenco", Anlage.find(1).name
  end

  test "get anlagen for selection field" do 
    anlagen = Anlage.get_anlagen_for_selection_field
    assert_equal 3, anlagen.size
    assert_equal 1, anlagen["Urenco"]
  end 

end
