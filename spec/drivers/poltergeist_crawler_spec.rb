require 'rails_helper'

RSpec.describe PoltergeistCrawler do

  let(:crawler) { PoltergeistCrawler.new }

  it 'should extend with Capyabara DSL' do
    expect(crawler).to respond_to(:visit)
    expect(crawler).to respond_to(:page)
    expect(crawler).to respond_to(:fill_in)
    expect(crawler).to respond_to(:click_link)
    expect(crawler).to respond_to(:current_url)
  end

  it 'should register new poltergeist driver instance' do
    expect(Capybara)
      .to receive(:register_driver)
    PoltergeistCrawler.new
  end

  it 'should parse page.body with Nokogiri' do
    expect(Nokogiri)
      .to receive('HTML')
    crawler.doc
  end

end
