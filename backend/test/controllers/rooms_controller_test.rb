require "test_helper"
# test_helper untuk load framework Minitest dan fixtures

class RoomsControllerTest < ActionDispatch::IntegrationTest
  fixtures :all
  # Memuat semua fixtures untuk pengujian

  setup do
    @room = rooms(:one)
  end

  test "halaman index untuk menampilkan semua room" do
    get rooms_path
    assert_response :success
  end

  test "membuat room baru" do
    assert_difference("Room.count") do
      post rooms_path, params: { room: { name: "Room Testing" } }
    end
    assert_redirected_to room_path(Room.last)
    assert_equal "Room created successfully", flash[:notice]
  end

  test "updates a room" do
    patch room_path(@room), params: { room: { name: "Update Room Testing" } }
    assert_redirected_to rooms_path
    @room.reload
    assert_equal "Update Room Testing", @room.name
    assert_equal "Room Update Room Testing was updated successfully", flash[:success]
  end


  test "menampilkan room dan pesan pada room tersebut" do
    get room_path(@room)
    assert_response :success
    assert_select "#messages"
  end
end
