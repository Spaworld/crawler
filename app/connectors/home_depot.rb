# Encapsulates instructions for
# navigating Home Depot
class HomeDepot < BaseConnector
  attr_reader :listing_attrs

  BASE_URL = 'http://www.homedepot.com/p/'
  ABBREV   = 'hd'

  def abbrev; ABBREV end

  def process_listing(node)
    id = node.id
    visit_product_page(id)
    return if page_not_found?
    fetch_product_attributes(id)
    store_product_attributes(@listing_attrs)
  end

  def visit_product_page(product_id)

  end


  def process_listings(nodes)
    nodes.each_with_index do |node, index|
      id = node[0]
      sku = node[1]
      # next if Listing.record_exists?(sku)
      next if Listing.data_present?(sku, 'hd')
      puts '>>> listing exists' if Listing.data_present?(sku, 'hd')
      puts "=== starting id: #{id} \
      | sku: #{sku} \
      | iteration: #{index}"
      visit_product_page(id)
      next if page_not_found?
      fetch_product_attributes(id)
      vendor_sku = @listing_attrs[:vendor_sku]
      vendor_url = @listing_attrs[:vendor_url]
      Listing.append_hd_url(
        vendor_sku,
        vendor_url)
      Listing.append_vendor_attrs(
        vendor_sku,
        @listing_attrs)
    end
  end

  def visit_product_page(hd_id)
    driver.visit("#{BASE_URL}#{hd_id}") unless hd_id.nil?
  end

  def fetch_product_attributes(hd_id)
    @listing_attrs =
      { vendor:       'hd',
        vendor_url:   driver.current_url,
        vendor_id:    driver.doc.at('#product_internet_number').text,
        vendor_sku:   driver.doc.at('.modelNo').text.split(' ').last,
        vendor_title: driver.doc.at('h1.product-title__title').text,
        vendor_price: driver.doc.at('#ajaxPrice').text.strip }
  end

  private

  def page_not_found?
    driver.current_url == BASE_URL ||
      driver.doc.at('.no-results').present? ||
      driver.doc.at('.content_margin_404page').present?
  end

end
