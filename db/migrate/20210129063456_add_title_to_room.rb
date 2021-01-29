class AddTitleToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :title, :string, null: false
  end
end
