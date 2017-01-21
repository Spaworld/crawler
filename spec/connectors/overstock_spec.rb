require 'rails_helper'
require 'shared_examples/a_driver'

RSpec.describe Overstock do

  let(:subject)   { Overstock.new(BillyDriver.new) }
  let(:connector) { subject }
  let(:driver)    { subject.driver }

  it_behaves_like('a driver')

  describe 'visiting the home page' do

    it 'should vist the home page' do
      expect {
        connector.visit_home_page
      }.to change {
        driver.current_url
      }.from('about:blank')
        .to(Overstock::BASE_URL)
    end

  end # visiting the home page

  describe 'searching for product' do

    context 'when the listing is not found' do

      # checks for hard 404 pages as
      # 'урюпинский микрорайон' will not have
      # any suggested searches
      it 'should identify hard 404' do
        node = build(:node, id: 'урюпинский микрорайон')
        connector.process_listing(node)
        expect(connector.send(:page_not_found?))
          .to be_truthy
      end

      # checks for alternative 404 page as
      # 'testorio' will return a page with
      # suggested searches
      it 'should identify a soft 404' do
        node = build(:node, id: 'testorio')
        connector.process_listing(node)
        expect(connector.send('page_not_found?'))
          .to be_truthy
      end

      it 'should raise a Page Not Found error' do
        node = build(:node, id: 'testorio')
        connector.process_listing(node)
        expect { connector.send(:page_not_found?) }
          .to output("Page not found\n")
          .to_stdout
      end

      it 'should return if the current url is blank' do
        allow(driver).to receive(:current_url)
          .and_return('about:blank')
        expect(connector.send('already_on_site?'))
          .to be_falsey
      end

    end # when listing page is not found

    context 'when the listing page is found' do

      before { driver.restart }

      it 'should search for product' do
        connector.visit_home_page
        expect {
          connector.search_for_product('20428979')
        }.to change {
          driver.current_url
        }.from(Overstock::BASE_URL)
          .to('https://www.overstock.com/Home-Garden/Anzzi-Ember-5.4-foot-Man-made-Stone-Classic-Soaking-Bathtub-in-Deep-Red-with-Sol-Freestanding-Faucet-in-Chrome/13776291/product.html?keywords=20428979&searchtype=Header')
      end

      it 'should proceed if the current url is has domain name in it' do
        allow(driver).to receive(:current_url)
          .and_return(Overstock::BASE_URL + '/stuff')
        expect(connector.send('already_on_site?'))
          .to be_truthy
      end

      it 'should proceed if the current url is the home page' do
        allow(driver).to receive(:current_url)
          .and_return(Overstock::BASE_URL)
        expect(connector.send('already_on_site?'))
          .to be_truthy
      end

    end # when listing is found

  end # listing page

  describe 'fetching product attributes' do

    before do
      sample_page = File.open("#{page_fixtures}/overstock/product.html")
      allow(driver).to receive(:doc)
        .and_return(Nokogiri::HTML(sample_page))
    end

    it 'should append vendor name' do
      expect{
        connector.fetch_product_attributes('abc')
      }.to change {
        connector.listing_attrs[:vendor]
      }.from(nil)
        .to('overstock')
    end

    # stubbing driver.current_url because
    # that's how 'vendor_url' is stored
    it 'should fetch listing page url' do
      allow(driver).to receive(:current_url)
        .and_return('abc.com')
      expect{
        connector.fetch_product_attributes('abc')
      }.to change {
        connector.listing_attrs[:vendor_url]
      }.from(nil)
        .to('abc.com')
    end

    it 'should fetch listing vebdor id' do
      expect{
        connector.fetch_product_attributes('abc')
      }.to change {
        connector.listing_attrs[:vendor_id]
      }.from(nil)
        .to('abc')
    end

    it 'should fetch listing vendor price' do
      expect{
        connector.fetch_product_attributes('abc')
      }.to change {
        connector.listing_attrs[:vendor_price]
      }.from(nil)
        .to('$6,999.00')
    end

    it 'should fetch listing vendor price' do
      expect{
        connector.fetch_product_attributes('abc')
      }.to change {
        connector.listing_attrs[:vendor_title]
      }.from(nil)
        .to('Anzzi Ember 5.4-foot Man-made Stone Classic Soaking Bathtub in Deep Red with Sol Freestanding Faucet in Chrome')
    end

    it 'should fetch listing vendor sku' do
      expect{
        connector.fetch_product_attributes('abc')
      }.to change {
        connector.listing_attrs[:vendor_sku]
      }.from(nil)
        .to('FT521-0027')
    end

  end # fetching product attributes

end
