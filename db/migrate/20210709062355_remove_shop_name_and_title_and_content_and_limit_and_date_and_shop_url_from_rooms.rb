class RemoveShopNameAndTitleAndContentAndLimitAndDateAndShopUrlFromRooms < ActiveRecord::Migration[6.1]
  def change
    remove_column :rooms, :shop_name, :string
    remove_column :rooms, :title, :string
    remove_column :rooms, :content, :text
    remove_column :rooms, :limit, :integer
    remove_column :rooms, :date, :datetime
    remove_column :rooms, :shop_url, :string
  end
end
