require "test_helper"
# test_helper untuk load framework Minitest dan fixtures

class RoomMessageTest < ActiveSupport::TestCase
  test "percobaan dengan data lengkap" do
    room = rooms(:one)
    message = RoomMessage.new(
      room: room,
      nickname: "TamaGo",
      color: "#abcdef",
      message: "Testing"
    )
    assert message.valid?
  end

  test "percobaan apabila tidak memiliki Nickname" do
    message = RoomMessage.new(message: "Hi", color: "#fff", room: rooms(:one))
    assert_not message.valid?
  end

  test "percobaan apabila tidak mengirimkan message" do
    message = RoomMessage.new(nickname: "Dave", color: "#123456", room: rooms(:one))
    assert_not message.valid?
  end
end
