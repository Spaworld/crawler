# Encapsulates instructions for
# navigating Home Depot
class HomeDepot < BaseConnector

  HOME_URL = 'http://www.homedepot.com'

  def set_home_page
    driver.visit(HOME_URL)
  end

  def get_listing_page(sku)
    driver.fill_in('headerSearch', with: sku)
    # driver.click_button('Submit Search')
    driver.find_field('headerSearch').native.send_keys(:return)
    parse_page(sku)
  end

  def parse_page(sku)
    if listing_found?(sku)
    append_url_to_listing(sku,
                          driver.current_url,
                          abbrev: 'hd')
    else
      return
    end
  end

  private

  def listing_found?(sku)
    driver.current_url != HOME_URL &&
      !driver.doc.find('An internal homedepot.com error occurred.') &&
      driver.doc.find("Model # #{sku}")
  end

end

