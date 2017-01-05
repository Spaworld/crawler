# Native listing with channel_urls
# pertaining to a retailing channel
class Listing < ActiveRecord::Base

  VENDORS = %W( hd menards houzz overstock lowes build hmb wayfair )

  validates_presence_of :sku
  validates_uniqueness_of :sku
  serialize :vendors, HashSerializer
  store_accessor :vendors, :hd, :wayfair, :lowes, :menards, :hmb, :houzz, :overstock, :build

  def self.append_vendor_attrs(sku, attrs)
    listing = find_by(sku: sku) || new(sku: sku)
    listing.vendors_will_change!
    listing.fetch_vendor_data(attrs)
    listing.save!
  end

  def self.record_exists?(sku)
    find_by(sku: sku).present?
  end

  def self.data_present?(sku, vendor)
    listing = find_by(sku: sku.strip)
    listing.present? &&
      listing.vendors["#{vendor}"].present?
  end

  def fetch_vendor_data(attrs)
    vendors[ attrs[:vendor] ] = ({
      id:    attrs[:vendor_id],
      sku:   attrs[:vendor_sku],
      url:   attrs[:vendor_url],
      title: attrs[:vendor_title],
      price: attrs[:vendor_price] })
  end

  VENDORS.each do |vendor|
    define_singleton_method("append_#{vendor}_url") do |sku, url|
      listing = find_by(sku: sku) || new(sku: sku)
      listing.send("#{vendor}_url=", url)
      listing.save!
    end
  end

  def self.prime_listing
    find_by(sku: sku) || new(sku: sku)
  end


end
