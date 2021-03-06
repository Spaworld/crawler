require 'billy'
require 'capybara/dsl'
require 'nokogiri'

# -inits a Poltergeist driver instance
# -inits page.doc instance parsed by Nokogiri
class BillyDriver

  include Capybara::DSL

  def initialize(driver = nil)
    Capybara.register_driver :poltergeist_billy do |app|
      options = {
        phantomjs_options: [
          '--ignore-ssl-errors=yes',
          "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}",
          '--load-images=no'
        ],
        phantomjs_logger: File.open("#{Rails.root}/spec/fixtures/logs/js_log.txt", 'w'),
        js_errors: false
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    Capybara.default_driver = :poltergeist_billy
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
    return unless @listing_url
    Listing.append_hd_url(sku, url)
  end

  def screenshot(name="screenshot_")
    page.driver.render("public/#{name}test.jpg", full: true)
  end

  # restarts browser to avoid
  # PhantomJS memory leak debuckle
  def restart
    page.driver.browser.restart
  end

end
