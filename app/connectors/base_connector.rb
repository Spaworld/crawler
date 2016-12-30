# Provides data manipulation layer
class BaseConnector

  attr_reader :driver

  def initialize(driver)
    validate_driver(driver)
    @driver = driver
  end

  def append_url_to_listing(sku, url, abbrev: '', force_update: false)
    return unless valid_options?(abbrev, force_update)
    Listing.send("append_#{abbrev}_url", sku, url, force_update)
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

  # Validates options keyword args
  def valid_options?(abbrev, force_update)
    abbrev.present? &&
      Listing::CHANNELS.include?(abbrev) &&
      [true, false].include?(force_update)
  end

end
