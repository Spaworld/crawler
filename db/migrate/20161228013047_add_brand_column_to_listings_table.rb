class AddBrandColumnToListingsTable < ActiveRecord::Migration
  def change
    add_column :listings, :brand, :string
  end
end
