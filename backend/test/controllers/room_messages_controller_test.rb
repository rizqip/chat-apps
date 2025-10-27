require "test_helper"
# test_helper untuk load framework Minitest dan fixtures

class RoomMessagesControllerTest < ActionDispatch::IntegrationTest
  fixtures :all
  # Memuat semua fixtures untuk pengujian

  setup do
    @room = rooms(:one)
    # Simulasikan login nickname untuk session
    post nickname_path, params: { nickname: "Tester" }
  end

  test "Percobaan mengirim pesan di room" do
    assert_difference("RoomMessage.count") do
      post room_room_messages_path(@room), params: { room_message: { room_id: @room.id, message: "Hello!" } }
    end

    assert_redirected_to room_path(@room)
  end

  test "percobaan apabila belum terdapat nickname" do
    # Hapus session
    delete nickname_path

    post room_room_messages_path(@room), params: { room_message: { room_id: @room.id, message: "Hello!" } }
    assert_redirected_to new_nickname_path
    assert_equal "Silakan masukkan nickname terlebih dahulu.", flash[:alert]
  end
end
