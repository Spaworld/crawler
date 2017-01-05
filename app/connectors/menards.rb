class Menards < BaseConnector

  attr_accessor :listing_attrs

  BASE_URL = 'http://www.menards.com/main/'

  def process_listings(nodes)
    nodes.each_with_index do |node, index|
      id = node[0]
      sku = node[1]
      next if Listing.record_exists?(sku)
      sleep(4) if index % 20 == 0
      puts "=== starting id: #{id} | iteration: #{index}"
      sleep(rand(0.1...3))
      visit_product_page(id)
      fetch_product_attributes(id)
      Listing.append_menards_url(@listing_attrs[:vendor_sku],
                                 @listing_attrs[:vendor_url])
    end
  end

  def visit_product_page(menards_id)
    driver.visit("#{BASE_URL}p-#{menards_id}.html") unless menards_id.nil?
    raise PageNotFoundError if page_not_found?
  end

  def fetch_product_attributes(menards_id)
    return if page_not_found?
    @listing_attrs =
      { vendor:      'menards',
        vendor_url:         driver.current_url,
        vendor_id:   menards_id,
        vendor_sku:  driver.doc.at('p.itemModelSku').children.last.text.strip,
        vendor_title:       driver.doc.at('.itemCenterContent span h2').text,
        vendor_price:       driver.doc.at('#totalItemPrice').children.first.text.strip }
  end

  private

  def page_not_found?
    driver.current_url == BASE_URL ||
      driver.doc.at('h5.error').present?
  end

end
