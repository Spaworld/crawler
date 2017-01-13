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

  # Constructs an ostruct
  # '{ id: vendor_id, sku: sku }'
  # based on vendor name injected
  def to_node(vendor)
    OpenStruct.new(id: vendors["#{vendor}"][:vendor_id],
                   sku: sku)
  end

  def self.get_price(sku)
    listing = find_by(sku: sku)
    return if listing.nil?
    listing.vendors[:hd][:price]
  end

  def self.data_present?(sku, vendor)
    listing = find_by(sku: sku.strip)
    listing.present? &&
      listing.vendors["#{vendor}"].present? &&
      listing.send("#{vendor}_url").present?
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

  def self.append_not_found(vendor,sku, id)
    listing = find_by(sku: sku) || return
    listing.vendors[vendor][:found?] = false
  end

  def self.page_not_found?(vendor, sku)
    listing = find_by(sku: sku)
    listing.vendors[vendor][:found?].nil?
  end

  VENDORS.each do |vendor|
    define_singleton_method("append_#{vendor}_url") do |sku, url|
      listing = find_by(sku: sku) || new(sku: sku)
      listing.send("#{vendor}_url=", url)
      listing.save!
    end
  end

end
