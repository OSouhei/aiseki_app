class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.text :conditions
      t.date :date
      t.integer :people_limit
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
