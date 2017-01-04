class Menards < BaseConnector

  attr_accessor :listing_attrs

  BASE_URL = 'http://www.menards.com/main/'

  def visit_product_page(menards_id)
    driver.visit("#{BASE_URL}p-#{menards_id}.html") unless menards_id.nil?
  end

  def fetch_product_attributes(menards_id)
    return if page_not_found?
    @listing_attrs = { url:         driver.current_url,
                       vendor_id:   menards_id,
                       vendor_sku:  driver.doc.at('p.itemModelSku').children.last.text.strip,
                       title:       driver.doc.at('.itemCenterContent span h2').text,
                       price:       driver.doc.at('#totalItemPrice').children.first.text.strip }
  end

  def store_product_attributes(listing_attrs)
    Listing.append_attrs(listing_attrs)
  end

  private

  def page_not_found?
    driver.current_url == BASE_URL ||
      driver.doc.at('h5.error').present?
  end

end
