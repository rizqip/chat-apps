class AddNicknameToRoomMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :room_messages, :nickname, :string
  end
end
