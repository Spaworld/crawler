# Provides data manipulation layer
class BaseConnector

  attr_reader :driver

  def initialize(driver)
    validate_driver(driver)
    @driver = driver
  end

  def store_attrs(sku, attrs)
    Listing.append_vendor_attrs(sku, attrs)
  end

  def restart
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
