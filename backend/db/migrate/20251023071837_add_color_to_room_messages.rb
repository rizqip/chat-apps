class AddColorToRoomMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :room_messages, :color, :string
  end
end
