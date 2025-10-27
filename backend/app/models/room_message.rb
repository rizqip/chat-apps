class RoomMessage < ApplicationRecord
  belongs_to :room

  validates :nickname, :message, presence: true

  after_create_commit do
    broadcast_append_to room, 
      target: "messages", 
      partial: "room_messages/message",
      locals: { room_message: self }
  end
end
