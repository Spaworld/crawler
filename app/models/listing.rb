# Native listing with channel_urls
# pertaining to a retailing channel
class Listing < ActiveRecord::Base

  VENDORS = %W( hd menards houzz overstock lowes build hmb wayfair )

  validates_presence_of :sku
  serialize :vendors, HashSerializer
  store_accessor :vendors, :hd, :wayfair, :lowes, :menards, :hmb, :houzz, :overstock, :build

  def self.append_vendor_attrs(sku, attrs)
    listing = find_by(sku: sku) || new(sku: sku)
    listing.fetch_vendor_data(attrs)
    listing.save!
  end

  def self.record_exists?(sku)
    find_by(sku: sku).present?
  end

  def fetch_vendor_data(attrs)
    vendors[attrs[:vendor]].merge!({
      id:    attrs[:vendor_id],
      sku:   attrs[:vendor_sku],
      url:   attrs[:vendor_url],
      title: attrs[:vendor_title],
      price: attrs[:vendor_price] }).to_json
  end

  VENDORS.each do |vendor|
    define_singleton_method("append_#{vendor}_url") do |sku, url|
      listing = find_by(sku: sku) || new(sku: sku)
      listing["#{vendor}_url"] = url
      listing.save!
    end
  end

end
