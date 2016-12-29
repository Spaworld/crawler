require 'rails_helper'

RSpec.describe HomeDepotConnector do

  describe 'initalization' do

    context 'when valid driver is injected' do

      before { @connector = HomeDepotConnector.new(PuffingBillyCrawler.new) }

      it 'should init with a driver' do
        expect(@connector).to respond_to(:driver)
      end

      it 'should init with a valid driver' do
        expect(@connector.driver.class).to eq(PuffingBillyCrawler)
      end

    end

    context 'when wrong driver type is injected' do

      it 'should not init' do
        expect{ HomeDepotConnector.new(Class.new) }
          .to raise_error(ArgumentError, 'Invalid driver')
      end

    end

    context 'when no driver is injected' do

      it 'should not init' do
        expect{ HomeDepotConnector.new(nil) }
          .to raise_error(ArgumentError, 'Invalid driver')
      end

    end

  end

  describe 'crawling' do

    let(:connector) { HomeDepotConnector.new(PuffingBillyCrawler.new) }

    before do
      @listing = create(:listing)
      sample_page = File.read("#{Rails.root}/spec/fixtures/standard_page.html")
      proxy.stub("http://www.homedepot.com/s/#{@listing.sku}")
        .and_return(text: sample_page)
    end

    describe 'visting listing pages' do

      it 'should visit listing page' do
        connector.get_listing_page_url(@listing.sku)
        expect(connector.driver.page)
          .to have_content('Home Depot')
      end

      it 'should handle wrong / empty sku injection' do
        expect{ connector.get_listing_page_url(nil) }
          .to_not raise_error
      end

      it 'should set listing_url attr' do
        expect(connector.listing_url).to be_empty
        connector.get_listing_page_url(@listing.sku)
        expect(connector.listing_url)
          .to eq("http://www.homedepot.com/s/#{@listing.sku}")
      end

    end

    it 'should append listing_url to listing via its driver' do
      url = "http://www.homedepot.com/s/#{@listing.sku}"
      sku = @listing.sku
      connector.get_listing_page_url(@listing.sku)
      expect(connector.driver).to receive(:append_url_to_listing)
        .with(sku, url)
      connector.process_listings([@listing.sku])
    end

    it 'should process a bulk of skus' do
      expect(connector).
        to receive(:get_listing_page_url)
        .with(@listing.sku)
      expect(connector.driver).
        to receive(:append_url_to_listing)
        .with(@listing.sku, any_args)
      connector.process_listings([@listing.sku])
    end

  end

end
