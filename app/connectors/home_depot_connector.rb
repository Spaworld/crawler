# set of instructions for
# crawling HomeDepot.com
class HomeDepotConnector

  attr_reader :driver, :listing_url

  def initialize(driver = PoltergeistCrawler.new)
    validate_driver(driver)
    @driver = driver
    @listing_url = String.new
  end

  def process_listings(skus)
    skus.each do |sku|
      get_listing_page_url(sku)
      append_url_to_listing(sku)
    end
  end

  def get_listing_page_url(sku)
    return unless sku.present?
    @driver.visit("http://www.homedepot.com/s/#{sku}")
    @listing_url = @driver.page.current_url
  end

  def append_url_to_listing(sku)
    return unless @listing_url
    Listing.append_hd_url(@listing_url, sku)
  end

  private

  def valid_driver?(driver)
    driver.present? &&
      driver.class.ancestors.include?(Capybara::DSL)
  end

  def validate_driver(driver)
    unless valid_driver?(driver)
      raise ArgumentError.new('Invalid driver')# unless valid_driver?(driver)
    end
  end

end
