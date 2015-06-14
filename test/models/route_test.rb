require 'test_helper'

class RouteTest < ActiveSupport::TestCase

  setup do 
    @route = routen(:one)
  end 
  
  test "erhoehe_indizes" do
    assert_equal 1, @route.id
    assert_equal 2, @route.durchfahrtsorte.size
    #ssert_equal 2, @route.durchfahrtsorte.where("durchfahrtsorte.index >= 1").size
    assert @route.erhoehe_durchfahrtsort_indizes 1
    assert @route.erhoehe_durchfahrtsort_indizes 2
  end
end
