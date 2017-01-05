class RemoveUrlColumnsFromListings < ActiveRecord::Migration
  def change
    change_table :listings do |t|
      t.remove :hd_url
      t.remove :menards_url
      t.remove :overstock_url
      t.remove :lowes_url
      t.remove :build_url
      t.remove :hmb_url
      t.remove :wayfair_url
      t.remove :houzz_url
    end
  end
end
