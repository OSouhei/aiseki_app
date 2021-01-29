class RemoveDateFromRoom < ActiveRecord::Migration[6.1]
  def change
    remove_column :rooms, :date, :date
  end
end
