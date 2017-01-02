require 'rails_helper'

RSpec.describe HomeDepot do

  let(:subject) { HomeDepot.new(BillyDriver.new) }

  #TODO add shared context with Driver
  # to test < (inheritance)
  context 'init' do

    context 'with valid driver injection' do

      it { is_expected.to respond_to(:driver) }

    end

    context 'with invalid driver injection' do

      it 'should raise ArgumentError exception' do
        expect { HomeDepot.new(nil) }
          .to raise_error(ArgumentError)
      end

    end

  end

  describe 'navigation' do

    let(:connector) { subject }

    describe 'setting home page' do

      it 'should navigate to home page' do
        expect(connector.driver)
          .to receive(:visit)
          .with(HomeDepot::HOME_URL)
        connector.set_home_page
      end

      it 'should set driver#page to homepage' do
        connector.set_home_page
        expect(connector.driver.page.body)
          .to include('Home Depot')
      end

    end

    describe 'getting listing page' do

      before do
        @driver = connector.driver
        connector.set_home_page
        file_path = 'lib/skus.csv'
        @sku = CSVFeedParser.fetch_skus(file_path).first
      end

      it 'should have cached home page' do
        expect(@driver.page)
          .to_not be_nil
      end

      it 'should fill in search bar with SKU' do
        allow(@driver)
          .to receive(:click_button)
        expect(@driver)
          .to receive(:fill_in)
          .with('headerSearch', { with: @sku })
        connector.get_listing_page(@sku)
      end

      it 'should check if listing page exists' do
        expect(connector)
          .to receive(:listing_page_found?)
        connector.get_listing_page(@sku)
      end

      it 'should handle nil arg passed to #listing_page_found' do
        expect{ connector.send(:listing_page_found?, nil) }
          .to_not raise_error

      end

      it 'should handle invalid arg passed to #listing_page_found' do
        expect{ connector.send(:listing_page_found?, self) }
          .to_not raise_error
      end

      context 'when listing exists' do

        it 'should navigate to listing page' do
          expect { connector.get_listing_page(@sku) }
            .to change { @driver.current_url }
            .from (HomeDepot::HOME_URL)
        end

        it 'should create new Listing' do
          expect { connector.get_listing_page(@sku) }
            .to change { Listing.count(1) }
        end

        it 'should update new Listing url' do
          connector.get_listing_page(@sku)
          expect(Listing.first.hd_url).to_not be_nil
          expect(Listing.first.hd_url).to_not eq(HomeDepot::HOME_URL)
        end

      end

      context 'when listing does not exist' do

        it 'should know that a listing page does not exist' do
          expect(connector.send(:listing_page_found?, 'huita'))
            .to be_falsey
        end

        it 'should not update an existing listing' do
          expect_any_instance_of(Listing)
            .to_not receive(:update)
          connector.get_listing_page('huita')
        end

      end

    end

  end

end
