# Native listing with channel_urls
# pertaining to a retailing channel
class Listing < ActiveRecord::Base

  validates_presence_of :sku
  validate :channel_urls_format

  CHANNELS = %w( hd menards overstock lowes build hmb wayfair houzz )

  def available_channel_urls
    channel_names = CHANNELS.map { |channel| "#{channel}_url" }
    channel_names.map do |name|
      attributes.fetch_values(name)
    end.flatten.compact
  end

  CHANNELS.each do |channel_name|
    define_singleton_method("append_#{channel_name}_url") do |url, sku|
      listing = find_by(sku: sku)
      listing.update_attributes!("#{channel_name}_url": url)
    end
  end

  private

  def channel_urls_format
    if available_channel_urls.any? { |url| url.scan(URI.regexp).empty? }
      errors.add(:base, message: 'malformed url')
    end
  end

end
