class AddShopNameToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :shop_name, :string
  end
end
