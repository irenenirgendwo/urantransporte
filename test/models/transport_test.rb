require 'test_helper'

class TransportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "anlage zu transport vorhanden" do 
    transport = Transport.find(1)
    assert_equal "Urenco", transport.start_anlage.name
  end

end
