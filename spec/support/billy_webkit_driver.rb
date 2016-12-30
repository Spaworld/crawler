require 'billy'
require 'capybara/dsl'
require 'nokogiri'

class BillyWebkitDriver

  include Capybara::DSL

  def initialize(driver = nil)
    Capybara.register_driver :webkit_billy do |app|
      options = {
        ignore_ssl_errors: true,
        proxy: { host: Billy.proxy.host,
                 port: Billy.proxy.port }
      }
      Capybara::Webkit::Driver.new(
        app, options)
    end

    Capybara.default_driver = :webkit_billy

    # page.driver.headers = {
    #   'DNT' => 1,
    #   'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0'
    # }

    Capybara.ignore_hidden_elements = false

  end

  def doc
    Nokogiri::HTML(page.body)
  end

end
