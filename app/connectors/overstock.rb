class Overstock < BaseConnector

  BASE_URL = 'https://www.overstock.com/'
  ABBREV   = 'overstock'

  def abbrev; ABBREV end

  def process_listing(node)
    visit_home_page
    search_for_product(node.id)
    return if page_not_found?
    fetch_product_attributes(node.id)
    store_product_attributes(node.id)
  end

  # Visits the home page
  # return if driver is already on home page
  def visit_home_page
    return if already_on_site?#driver.current_url == BASE_URL
    close_popups
    driver.visit(BASE_URL)
  end

  # Identifies and closes popups
  def close_popups
    return if driver.doc.at('.cb_close').nil?
    driver.first('.cb_close').click
  end

  # conducts search for product using
  # passed-in product identifier
  def search_for_product(overstock_id)
    driver.fill_in('keywords', with: overstock_id)
    driver.first('.os-icon-magnify').click
  end

  # fetches product attributes from
  # elements found on page
  def fetch_product_attributes(overstock_id)
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

  # checks if driver is already pointing
  # to overstock.com/*
  def already_on_site?
    driver.current_url != 'about:blank' &&
      driver.current_url.include?(BASE_URL)
  end

end
