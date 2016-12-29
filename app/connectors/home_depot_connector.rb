# set of instructions for
# crawling HomeDepot.com
class HomeDepotConnector

  attr_reader :driver, :listing_url

  def initialize(driver = PoltergeistCrawler.new)
    validate_driver(driver)
    @driver = driver
    @listing_url = String.new
  end

  def get_listing_page_url(sku)
    return unless sku.present?
    @driver.visit("http://www.homedepot.com/s/#{sku}")
    @listing_url = @driver.page.current_url
  end

  def process_listings(skus)
    skus.each do |sku|
      get_listing_page_url(sku)
      @driver.append_url_to_listing(sku, @listing_url)
    end
  end

  private

  def valid_driver?(driver)
    driver.present? &&
      driver.class.ancestors.include?(Capybara::DSL)
  end

  def validate_driver(driver)
    unless valid_driver?(driver)
      raise ArgumentError.new('Invalid driver')
    end
  end

end
