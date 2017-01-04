require 'rails_helper'
require 'shared_examples/a_driver'

RSpec.describe Menards do

  let(:subject) { Menards.new(BillyDriver.new) }

  it_behaves_like('a driver')

  describe 'crawling' do

    before do
      product_page = File.read("#{page_fixtures}/menards/product.html")
      proxy.stub('http://www.menards.com/main/p-1482823193202.html')
        .and_return(body: product_page)
    end

    let(:connector) { subject }
    let(:driver)    { subject.driver }

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

        it 'should store product page url' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:url]).to_not be_nil
        end

        it 'should store product\'s vendor id' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor_id]).to_not be_nil
        end

        it 'should store product\'s vendor sku' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:vendor_sku]).to_not be_nil
        end

        it 'should store product\'s vendor title' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:title]).to_not be_nil
        end

        it 'should store product\'s vendor price' do
          connector.fetch_product_attributes('1482823193202')
          expect(connector.listing_attrs[:price]).to_not be_nil
        end

      end # specific attributes

    end # fetching product attributes

  end # crawling

end
