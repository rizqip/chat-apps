class RemoveUserIdFromRoomMessages < ActiveRecord::Migration[8.1]
  def change
    remove_column :room_messages, :user_id, :integer
  end
end
