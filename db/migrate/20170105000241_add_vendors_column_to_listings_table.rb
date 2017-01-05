class AddVendorsColumnToListingsTable < ActiveRecord::Migration
  def change
    add_column :listings, :vendors, :jsonb,
      default: { overstock: {},
                 wayfair:   {},
                 lowes:     {},
                 hmb:       {},
                 hd:        {},
                 houzz:     {},
                 menards:   {},
                 build:     {} }
  end
end

