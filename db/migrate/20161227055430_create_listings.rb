class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :sku
      t.string :hd_url
      t.string :menards_url
      t.string :overstock_url
      t.string :lowes_url
      t.string :build_url
      t.string :hmb_url
      t.string :wayfair_url
      t.string :houzz_url

      t.timestamps null: false
    end
  end
end
