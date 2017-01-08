# fetches listing data from local file
# stored manually in /lib/wayfair_batch
# does not inherit from BaseConnector
# since no remote access data is required
class Wayfair

  attr_reader :page_nodes, :listing_nodes, :listings

  def initialize
    @page_nodes     = []
    @listing_nodes  = []
    @listings       = []
  end

  # compiles an array of raw
  # HTML pages
  def fetch_page_nodes
    (1..12).each do |file_name|
      body = File.open("#{Rails.root}/lib/wayfair_batch/#{file_name}.html")
      @page_nodes.push(Nokogiri::HTML(body))
    end
  end

  # extracts listings' data
  # from raw HTML pages
  def fetch_listing_nodes
    @page_nodes.each do |node|
      all_rows = node.css('table')[1].css('tr:not(.directionheader)')
      all_rows.each do |row|
        @listing_nodes.push(
          row.css('td')
        )
      end
    end
  end

  # compiles an array of listings
  # attributes
  def compile_listings
    @listing_nodes.each do |node|
      listing_attr =
        { vendor:       'wayfair',
          vendor_url:   node.at('a')['href'],
          vendor_id:    node[16].text.strip,
          vendor_sku:   node[1].text.strip,
          vendor_title: node[2].text.strip }
      listing_attr[:vendor_price] =
        Listing.get_price(listing_attr[:vendor_sku])
      @listings.push(listing_attr)
    end
  end

  # stores / updates listing attrs
  # using data in @listings array
  def process_listing_nodes(listings)
    listings.each_with_index do |hash, index|
      id  = hash[:vendor_id]
      sku = hash[:vebdor_sku]
      vendor_sku = hash[:vendor_sku]
      vendor_url = hash[:vendor_url]
      next if Listing.data_present?(vendor_sku, 'wayfair')
      puts "=== starting id: #{id} \
      | sku: #{sku} \
      | iteration: #{index}"
      Listing.append_wayfair_url(
        vendor_sku,
        vendor_url)
      Listing.append_vendor_attrs(
        vendor_sku,
        hash)
    end
  end

end

