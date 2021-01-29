class RemoveConditionsFromRoom < ActiveRecord::Migration[6.1]
  def change
    remove_column :rooms, :conditions, :text
  end
end
