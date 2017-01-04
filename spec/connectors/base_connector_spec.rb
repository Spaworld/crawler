require 'rails_helper'
require 'shared_examples/a_driver'

RSpec.describe BaseConnector do

  let(:subject) { BaseConnector.new(BillyDriver.new) }

  it_behaves_like('a driver')

  describe 'data manipulation' do

    let(:connector) { subject }

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
