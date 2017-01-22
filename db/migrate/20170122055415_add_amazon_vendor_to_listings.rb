class AddAmazonVendorToListings < ActiveRecord::Migration
  def change
    add_column :listings, :amazon_url, :string
  end
end
