# Provides data manipulation layer
class BaseConnector

  attr_reader :driver

  def initialize(driver)
    validate_driver(driver)
    @driver = driver
  end

  def restart_driver
    driver.restart
  end

  def store_product_attributes(listing_attrs)
    sku = listing_attrs[:vendor_sku]
    url = listing_attrs[:vendor_url]
    Listing.append_menards_url(sku, url)
    Listing.append_vendor_attrs(sku, listing_attrs)
  end

  private

  def valid_driver?(driver)
    driver.class.include?(Capybara::DSL)
  end

  def validate_driver(driver)
    unless valid_driver?(driver)
      raise ArgumentError.new('Invalid driver')
    end
  end

end
