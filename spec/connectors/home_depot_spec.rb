require 'rails_helper'

RSpec.describe HomeDepot do

  let(:subject) { HomeDepot.new(BillyDriver.new) }

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

      it 'should click Search button' do
        allow(@driver)
          .to receive(:fill_in)
        expect(@driver)
          .to receive(:click_button)
          .with('Submit Search')
        connector.get_listing_page(@sku)
      end

      context 'when listing exists' do

        it 'should navigate to listing page' do
          expect { connector.get_listing_page(@sku) }
            .to change { @driver.current_url }
        end

      end

      context 'when listing does not exist' do

        it 'should check if page exists' do
          expect { connector.get_listing_page('123') }
            .to change { @driver.current_url }
        end

      end

    end

  end

end
