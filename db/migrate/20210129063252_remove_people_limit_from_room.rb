class RemovePeopleLimitFromRoom < ActiveRecord::Migration[6.1]
  def change
    remove_column :rooms, :people_limit, :integer
  end
end
