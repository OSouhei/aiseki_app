class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :to
      t.integer :by
      t.integer :room_id
      t.boolean :checked, null: false, default: false

      t.timestamps
    end
  end
end
