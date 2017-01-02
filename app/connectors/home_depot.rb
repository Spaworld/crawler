# Encapsulates instructions for
# navigating Home Depot
class HomeDepot < BaseConnector

  HOME_URL = 'http://www.homedepot.com/'

  def process_listings(skus)
    set_home_page
    skus.each do |sku|
      puts "--- starting sku: #{sku}"
      get_listing_page(sku)
      skus.delete(sku)
    end
  end

  def set_home_page
    driver.visit(HOME_URL)
  end

  def get_listing_page(sku)
    return if Listing.record_exists?(sku)
    driver.fill_in('headerSearch', with: sku)
    driver.find_field('headerSearch').native.send_keys(:return)
    puts ">>> listing page found? #{listing_page_found?(sku)}, | SKU: #{sku}"
    listing_page_found?(sku) ? parse_page(sku) : return
  end

  def parse_page(sku)
    append_url_to_listing(sku,
                          driver.current_url,
                          abbrev: 'hd')
  end

  private

  def listing_page_found?(sku)
    # sleeping here to avoid stupid race conditions
    # caused by outgoing tracking pixel GETs
    sleep(0.5)
    driver.doc.at('.modelNo').present?
  end

end

