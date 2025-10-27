require "test_helper"
# test_helper untuk load framework Minitest dan fixtures

class RoomTest < ActiveSupport::TestCase
  test "memastikan koneksi antara Room dan RoomMessage" do
    room = rooms(:one)
    assert_respond_to room, :room_messages
  end
end
