require 'rails_helper'
require 'shared_examples/a_driver'

RSpec.describe Overstock do

  let(:subject)   { Overstock.new(BillyDriver.new) }
  let(:connector) { subject }
  let(:driver)    { subject.driver }

  it_behaves_like('a driver')

  it 'should identify hard 404' do
    connector.process_listing(['урюпинский микрорайон', '1232'], 1)
    expect(connector.page_not_found?)
      .to be_truthy
  end

  it 'should identify a soft 404' do
    connector.process_listing(['testorio', '23423'], 1)
    expect(connector.page_not_found?)
      .to be_truthy
  end

  it 'should vists the home page' do
    expect {
      connector.visit_home_page
    }.to change {
      driver.current_url
    }.from('about:blank')
      .to(Overstock::BASE_URL)
  end

  it 'should search for product' do
    connector.visit_home_page
    expect {
      connector.search_for_product('20428979')
    }.to change {
      driver.current_url
    }.from(Overstock::BASE_URL)
      .to('https://www.overstock.com/Home-Garden/Anzzi-Ember-5.4-foot-Man-made-Stone-Classic-Soaking-Bathtub-in-Deep-Red-with-Sol-Freestanding-Faucet-in-Chrome/13776291/product.html?keywords=20428979&searchtype=Header')
  end

  it 'should fetch product attributes' do
    sample_page = File.open("#{page_fixtures}/overstock/product.html")
    allow(driver).to receive(:doc)
      .and_return(Nokogiri::HTML(sample_page))
    connector.fetch_product_attributes('foo', '123')
  end

  it 'should skip iteration when no listing if found' do
    missing_page = File.open("#{page_fixtures}/overstock/product.html")
    allow(driver).to receive(:doc)
      .and_return(Nokogiri::HTML(missing_page))
    expect {
    connector.fetch_product_attributes('foo', 'bar')
    }.to output{ '>>> page not found. Skipping' }
      .to_stdout
  end

end
