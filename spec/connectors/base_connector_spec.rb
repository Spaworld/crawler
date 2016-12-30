require 'rails_helper'

RSpec.describe BaseConnector do

  context 'initialization' do

    describe 'driver' do

      let(:subject) { BaseConnector.new(BillyWebkitDriver.new) }

      it { is_expected.to respond_to(:driver) }

      it 'should have a valid driver' do
        connector = BaseConnector.new(
          PuffingBillyCrawler.new)
        expect(connector.driver.class)
          .to eq(PuffingBillyCrawler)
      end

      it 'should not railse Argument Error when /
      valid driver is injected' do
        valid_driver = PuffingBillyCrawler.new
        expect { BaseConnector.new(valid_driver) }
          .to_not raise_error
      end

      it 'should raise Invalid driver when nil /
      driver is injected' do
        expect { BaseConnector.new(nil) }
          .to raise_error(ArgumentError, 'Invalid driver')
      end

      it 'should raise Invalid driver when falsey /
      driver is injected' do
        expect { BaseConnector.new(Class.new) }
          .to raise_error(ArgumentError, 'Invalid driver')
      end

    end

  end

  context 'crawling' do

    let(:subject) { BaseConnector.new(PuffingBillyCrawler.new) }

    it 'is able to navigate to pages' do
      subject.driver.visit(HomeDepot::HOME_URL)
      expect(subject.driver.page)
        .to have_content('Home Depot')
    end

  end

  context 'data manipulation' do

    let(:connector) { BaseConnector.new(PuffingBillyCrawler.new) }

    describe 'appending a url to listing' do

      it 'should call #append_url_to_listing' do
        expect(Listing).to receive(:append_hd_url)
          .with('sku', 'url', false)
        connector.append_url_to_listing('sku', 'url', abbrev: 'hd')
      end

      it 'should not force listing update by default' do
        expect(Listing).to receive(:append_hd_url)
          .with(any_args, false)
        connector.append_url_to_listing('sku', 'url', abbrev: 'hd')
      end

      it 'should handle nil channel abbreviation injection' do
        expect(Listing).to_not receive(:append_hd_url)
        connector.append_url_to_listing('sku', 'url', abbrev: nil)
      end

      it 'should handle nil channel abbreviation injection' do
        expect { connector.append_url_to_listing('sku', 'url', abbrev: nil) }
          .to_not raise_error
      end

      it 'should handle wrong keys in options hash' do
        expect {connector.append_url_to_listing('sku', 'url', foo: 'bar') }
          .to raise_error(
        ArgumentError)
      end

      it 'should handle no options hash injection' do
        expect(Listing).to_not receive(:append_hd_url)
        connector.append_url_to_listing('foo', 'bar')
      end

      it 'should handle new Hash as options hash injection' do
        expect(Listing).to_not receive(:append_hd_url)
        connector.append_url_to_listing('foo', 'bar', Hash.new)
      end

      it 'should handle empty options hash injection' do
        expect(Listing).to_not receive(:append_hd_url)
        connector.append_url_to_listing('foo', 'bar', {})
      end

    end

  end

end
