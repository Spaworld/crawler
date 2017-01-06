class Houzz < BaseConnector

  attr_accessor :listing_attrs

  LOGIN_URL = 'https://www.houzz.com/signin/'
  ADMIN_URL = "https://www.houzz.com/manageInventory/vname=#{ENV['HOUZZ_LOGIN']}"
  AUTH_URL = 'https://www.houzz.com:443/authorize'

  def process_listings
    login
    visit_admin_panel
  end

  def login
    driver.visit(LOGIN_URL)
    driver.fill_in(:username, with: ENV['HOUZZ_LOGIN'])
    driver.fill_in(:password, with: ENV['HOUZZ_PSWRD'])
    driver.click_button('Sign In')
  end

  def visit_admin_panel
    return unless logged_in?
    (0..1615).step(15) do |group|
      driver.visit("#{ADMIN_URL}/p/#{group}")
      parse_listings_data
    end
  end

  def parse_listings_data
    nodes = driver.doc.css('tr.listingRow')
    nodes.each do |node|
      compile_listing_attrs(node)
      vendor_sku = @listing_attrs[:vendor_sku]
      vendor_url = @listing_attrs[:vendor_url]
      next if Listing.data_present?(vendor_sku, 'houzz')
      Listing.append_houzz_url(
        vendor_sku,
        vendor_url)
      Listing.append_vendor_attrs(
        vendor_sku,
        @listing_attrs)
    end
  end

  def compile_listing_attrs(node)
    @listing_attrs =
      { vendor:      'houzz',
        vendor_url:   node.at('.col-pid a')['href'],
        vendor_id:    node.at('.col-pid').text,
        vendor_sku:   node.at('.col-sku').text,
        vendor_title: node.at('.col-title').text,
        vendor_price: node.at('.col-price').text }
  end

  def logged_in?
    sleep(rand(2..2.12))
    driver.doc.at('#navMyHouzz').present?
  end

end
