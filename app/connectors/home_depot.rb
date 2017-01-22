# Encapsulates instructions for
# navigating Home Depot
class HomeDepot < BaseConnector

  BASE_URL = 'http://www.homedepot.com/p/'
  ABBREV   = 'hd'

  def abbrev; ABBREV end

  def process_listing(node)
    visit_product_page(node.id)
    return if page_not_found?
    fetch_product_attributes(node.id)
    store_product_attributes(@listing_attrs)
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
        vendor_title: driver.doc.at('.product-title').text,
        vendor_price: driver.doc.at('#ajaxPrice').text.strip }
  end

  private

  def page_not_found?
    driver.current_url != BASE_URL ||
      driver.doc.at('.no-results').present? ||
      driver.doc.at('.content_margin_404page').present?
  end

end
