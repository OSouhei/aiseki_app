class AddLimitToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :limit, :integer, null: false
  end
end
