require 'capybara/poltergeist'
require 'capybara/dsl'
require 'nokogiri'

# -inits a Poltergeist driver instance
# -inits page.doc instance parsed by Nokogiri
class PoltergeistCrawler

  include Capybara::DSL

  def initialize(driver = nil)
      Capybara.register_driver :poltergeist_crawler do |app|
        Capybara::Poltergeist::Driver.new(app, {
          :js_errors => false,
          :inspector => false,
          :timeout   => 123,
          phantomjs_logger: open('/dev/null')
        })
      end
      Capybara.run_server = false
      Capybara.default_driver = :poltergeist_crawler
      page.driver.headers = {
        'DNT' => 1,
        'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0'
      }
      Capybara.ignore_hidden_elements = false
  end

  def doc
    Nokogiri::HTML(page.body)
  end

  def append_url_to_listing(sku, url)
    Listing.append_hd_url(sku, url)
  end

end
