class AddNameAndThemeAndMessageToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :name, :string
    add_column :rooms, :theme, :string
    add_column :rooms, :message, :text
  end
end
