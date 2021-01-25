class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end

    add_index :members, :user_id
    add_index :members, :room_id
    add_index :members, [:user_id, :room_id], unique: true
  end
end
