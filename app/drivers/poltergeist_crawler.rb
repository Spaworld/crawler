require 'capybara/poltergeist'
require 'capybara/dsl'
require 'nokogiri'
require_relative '../connectors/base_connector'

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
        phantomjs_logger: open('/dev/null'),
        phantomjs_options: [
        '--load-images=no'
        ]
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

  def append_url_to_listing(sku, url, abbrev)
    channel = translate_channel(abbrev)
    Listing.send("append_#{channel}_url", sku, url, force_update: false)
  end

  def screenshot(name="public_screenshot_")
    page.driver.render("public/#{name}.jpg", full: true)
  end

  # restarts browser to avoid
  # PhantomJS memory leak debuckle
  def restart
    page.driver.browser.restart
  end

end
