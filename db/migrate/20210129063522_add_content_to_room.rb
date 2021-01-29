class AddContentToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :content, :text
  end
end
