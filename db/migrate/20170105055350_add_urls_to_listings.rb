class AddUrlsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :hd_url, :string
    add_column :listings, :overstock_url, :string
    add_column :listings, :menards_url, :string
    add_column :listings, :hmb_url, :string
    add_column :listings, :build_url, :string
    add_column :listings, :houzz_url, :string
    add_column :listings, :lowes_url, :string
    add_column :listings, :wayfair_url, :string
  end
end
