require 'rails_helper'

RSpec.describe HomeDepotConnector do

  let(:connector) { HomeDepotConnector.new }

  it 'should visit the product page' do
    expect_any_instance_of(Capybara::Session).to receive(:visit)
      .with('http://www.homedepot.com/s/123')
    connector.get_listing_page('123')
  end

  it 'should append url to listing' do
    fake_page = double('page', current_url: 'foo.com')
    allow(Capybara)
      .to receive(:page)
      .and_return(fake_page)
    expect(Listing).to receive(:append_hd_url)
    connector.append_url_to_listing('123')
  end

  describe 'bulk sku processing' do

    before do
      allow(Listing).to receive(:append_hd_url)
      allow(connector).to receive(:visit)
    end

    it 'should get listing pages for skus' do
      expect(connector)
        .to receive(:get_listing_page)
        .with('123')
        .thrice
      connector.process_listings(%w( 123 123 123))
    end

    it 'should get listing pages for skus' do
      expect(connector)
        .to receive(:append_url_to_listing)
        .with('123')
        .thrice
      connector.process_listings(%w( 123 123 123))
    end

  end

end
