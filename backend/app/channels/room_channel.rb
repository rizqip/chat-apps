class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:id])
    stream_from "room_#{room.id}"
    puts "=== Action Cable: Subscribed to room_#{room.id} ==="
  end

  def unsubscribed
    puts "=== Action Cable: Unsubscribed ==="
  end
end