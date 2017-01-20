class Overstock < BaseConnector

  attr_reader :listing_attrs

  BASE_URL = 'https://www.overstock.com/'
  ABBREV   = 'overstock'

  def abbrev; ABBREV end

  def process_listing(node)
    id = node.id
    visit_home_page
    search_for_product(id)
    fetch_product_attributes(id)
    store_product_attributes(id)
  end

  # Visits the home page
  # raises page_not_found if
  # connection to host cannot
  # be established
  def visit_home_page
    begin
    return if driver.current_url == BASE_URL
    driver.visit(BASE_URL)
    rescue PageNotFound
      Notifier.raise_page_not_found
      return
    end
    # raise PageNotFound if page_not_found?
  end

  def search_for_product(overstock_id)
    driver.fill_in('keywords', with: overstock_id)
    driver.first('.os-icon-magnify').click
  end

  # def process_listing(node, index)
  #   visit_home_page
  #   id = node[0]
  #   sku = node[1]

  #   search_for_product(id)

  #   if page_not_found?
  #     puts '>>> page not found'
  #     return
  #   end

  #   fetch_product_attributes(id, sku)
  #   vendor_sku = @listing_attrs[:vendor_sku]
  #   vendor_url = @listing_attrs[:vendor_url]
  #   Listing.append_menards_url(
  #     vendor_sku,
  #     vendor_url)
  #   Listing.append_vendor_attrs(
  # vendor_sku,
  # @listing_attrs)
  # end

  # def process_listings(nodes)
  #   visit_home_page
  #   nodes.each_with_index do |node, index|
  #     id = node[0]
  #     sku = node[1]
  #     next if Listing.data_present?(sku, 'overstock')
  #     # next if Listing.page_not_found?(sku, 'overstock')
  #     puts "=== starting id: #{id} \
  #     | sku: #{sku} \
  #     | iteration: #{index}"
  # search_for_product(id)
  # if page_not_found? || @listing_attrs.nil?
  #   puts '>>> page not found. Skipping'
  #   Listing.append_not_found('overstock', sku, id)
  #   next
  # end
  # fetch_product_attributes(id, sku)
  # vendor_sku = @listing_attrs[:vendor_sku]
  # vendor_url = @listing_attrs[:vendor_url]
  # Listing.append_menards_url(
  # vendor_sku,
  # vendor_url)
  # Listing.append_vendor_attrs(
  # vendor_sku,
  # @listing_attrs)
  # end
  # end



  def fetch_product_attributes(overstock_id, sku)
    @listing_attrs =
      { vendor:      'overstock',
        vendor_url:   driver.current_url,
        vendor_id:    overstock_id,
        vendor_price: driver.doc.search('.monetary-price-value').text.strip,
        vendor_title: driver.doc.at('.product-title h1').text.strip,
        vendor_sku:   driver.doc.search(".//td[@itemprop='mpn']").text.strip }
  end

  # stores listing.vendors[:vendor] data
  # and listing.vendor_url
  def store_product_attributes(listing_attrs)
    sku = listing_attrs[:vendor_sku]
    url = listing_attrs[:vendor_url]
    Listing.append_menards_url(sku, url)
    Listing.append_vendor_attrs(sku, listing_attrs)
  end

  private

  def page_not_found?
    if driver.doc.at('.whoops').present? ||
        driver.doc.at('.autocorrect-msg').present?
      Notifier.raise_page_not_found
      return true
    end
  end

end
