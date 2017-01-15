class Menards < BaseConnector

  attr_accessor :listing_attrs

  BASE_URL = 'http://www.menards.com/main/'
  ABBREV   = 'menards'

  def abbrev; ABBREV end

  def process_listing(node)
    id  = node.id
    visit_product_page(id)

    return if page_not_found?
    fetch_product_attributes(id)
    store_product_attributes(@listing_attrs)
  end

  def visit_product_page(menards_id)
    driver.visit("#{BASE_URL}p-#{menards_id}.html") unless menards_id.nil?
  end

  # compiles a hash of fetched
  # product listing attributes
  def fetch_product_attributes(menards_id)
    @listing_attrs =
      { vendor:      'menards',
        vendor_url:   driver.current_url,
        vendor_id:    menards_id,
        vendor_sku:   driver.doc.at('p.itemModelSku').children.last.text.strip,
        vendor_title: driver.doc.at('.itemCenterContent span h2').text,
        vendor_price: driver.doc.at('#totalItemPrice').children.first.text.strip }
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

  # identifies a 404 if
  # elems are found on page
  def page_not_found?
    if driver.current_url == BASE_URL ||
        driver.doc.at('h5.error').present? ||
        (driver.doc.at('h3.resettitle').present? &&
         driver.doc.at('h3.resettitle').text.include?('404 error'))
      Notifier.raise_page_not_found
      return true
    end
  end

end
