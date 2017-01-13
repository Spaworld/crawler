require 'rails_helper'
require 'shared_examples/a_driver'

RSpec.describe Menards do

  let(:subject)   { Menards.new(BillyDriver.new) }
  let(:connector) { subject }
  let(:driver)    { subject.driver }

  it_behaves_like('a driver')

  describe 'crawling' do

    before do
      product_page = File.read("#{page_fixtures}/menards/product.html")
      proxy.stub('http://www.menards.com/main/p-1482823193202.html')
        .and_return(body: product_page)
    end

    describe 'visiting product pages' do

      it 'should have a BASE URL' do
        expect(Menards::BASE_URL)
          .to_not be_nil
      end

      it 'should visit the product url' do
        connector.visit_product_page('1482823193202')
        expect(driver.current_url)
          .to eq('http://www.menards.com/main/p-1482823193202.html')
      end

      context 'when menards product id is nil' do

        it 'should not visit the product page' do
          expect { connector.visit_product_page(nil) }
            .to_not change{ driver.current_url }
        end

        it 'should not parse product attrs' do
          expect(driver).to_not receive(:visit)
          connector.visit_product_page(nil)
        end

      end # when product_id.nil?

    end # visting product pages

    describe 'fetching product attributes' do

      before do
        connector.visit_product_page('1482823193202')
      end

      it 'should be able to product attributes' do
        expect { connector.fetch_product_attributes('1482823193202') }
          .to change { connector.listing_attrs }
          .from(nil)
          .to(a_kind_of(Hash))
      end

      context 'specific attributes' do

        it 'should store product vendor' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor])
            .to eq('menards')
        end

        it 'should store product page url' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor_url])
            .to eq('http://www.menards.com/main/p-1482823193202.html')
        end

        it 'should store product\'s vendor id' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor_id])
            .to eq('1482823193202')
        end

        it 'should store product\'s vendor sku' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor_sku])
            .to eq('FT521BL-0025')
        end

        it 'should store product\'s vendor title' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor_title])
            .to eq('ANZZI Ember 5.4 ft. Man-Made Stone Slipper Flatbottom Non-Whirlpool Bathtub in Regal Blue and Kros Faucet in Chrome')
        end

        it 'should store product\'s vendor price' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor_price])
            .to eq('$6,499.00')
        end

      end # specific attributes

    end # fetching product attributes

    context 'when listing page is not found' do

      before do
        not_found_page = File.read("#{page_fixtures}/menards/404.html")
        proxy.stub('http://www.menards.com/main/p-kozladoy.html')
          .and_return(body: not_found_page)
      end

    end # not-found message

  end # crawling

  context 'storing product attributes' do

    it 'should stor product attributes' do
      pending
  end

    it 'should store product attributes' do
      expect_any_instance_of(BaseConnector)
        .to receive(:store_attrs)
        .with('123', a_kind_of(Hash))
      connector.store_attrs('123', {})
    end

    it 'should append product attrs to listing vendor' do
      Listing.append_menards_url( '123', 'foo.com' )
    end

  end # storing attributes

end # class
