class AddDateToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :date, :datetime
  end
end
