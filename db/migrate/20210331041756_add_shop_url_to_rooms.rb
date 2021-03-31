class AddShopUrlToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :shop_url, :string
  end
end
