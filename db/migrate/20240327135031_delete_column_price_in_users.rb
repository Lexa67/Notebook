class DeleteColumnPriceInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :price
  end
end

