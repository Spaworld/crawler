# Encapsulates instructions for
# navigating Home Depot
class HomeDepot < BaseConnector

  HOME_URL = 'http://www.homedepot.com'

  def set_home_page
    driver.visit(HOME_URL)
  end

  def get_listing_page(sku)
    driver.fill_in('headerSearch', with: sku)
    driver.click_button('Submit Search')
    listing_found?
    # append_url_to_listing(sku,
    #                       driver.current_url,
    #                       abbrev: 'hd')
  end

  private

  def listing_found?
    puts driver.current_url
  end

end

