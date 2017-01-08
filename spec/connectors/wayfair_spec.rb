require 'rails_helper'
require 'shared_examples/a_driver'

RSpec.describe Wayfair do

  let(:connector) { Wayfair.new }

  describe 'parsing' do

    it 'should fetch raw listing nodes from local pages' do
      expect {
        connector.fetch_page_nodes
      }.to change {
       connector.page_nodes.count }
         .from(0)
         .to(12)
    end

    it 'shuold extract listings\' data from raw html pages' do
      connector.fetch_page_nodes
      expect { connector.fetch_listing_nodes }
        .to change { connector.listing_nodes.count }
        .from(0)
        .to(1147)
    end

    it 'should compile listing attributes from raw listing data nodes' do
      connector.fetch_page_nodes
      connector.fetch_listing_nodes
      expect { connector.compile_listings }
        .to change { connector.listings.count }
        .from(0)
        .to(1147)
    end

  end

  describe 'storing data' do

    before do
      @listing = create(:listing, sku: '123')
      @listings = [{
        vendor_sku:   '123',
        vendor_url:   'abc.com',
        vendor_id:    '123123',
        vendor_title: 'foo',
        vendor_price: '$1.99' }]
    end

    it 'should update listings\' attributes' do
      expect {
        connector.process_listing_nodes(@listings)
      }.to change {
        @listing.reload.vendors }
    end

    it 'should update listings\' wayfair_url' do
      expect {
        connector.process_listing_nodes(@listings)
      }.to change {
        @listing.reload.wayfair_url }
          .from(nil)
          .to('abc.com')
    end

  end

end
