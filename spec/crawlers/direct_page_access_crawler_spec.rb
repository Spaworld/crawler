require 'rails_helper'

RSpec.describe DirectPageAccessCrawler do

  let(:subject) { DirectPageAccessCrawler.new(connector) }
  let(:connector) { Menards.new(BillyDriver.new) }
  let(:crawler)   { subject }

  describe 'init' do

    it { is_expected.to respond_to(:connector) }

    it 'should init with a vendor connector' do
      expect(crawler.connector.class).to eq(Menards)
    end

    it 'should init with a valid vendor connector' do
      expect { DirectPageAccessCrawler.new(nil) }
        .to raise_error(InvalidConnectorError, 'Invalid Driver')
    end

    describe 'driver validation' do

      it 'should check if a connector is an instance of BaseConnector' do
        fake_connector = double('connector', is_a?: BaseConnector)
        expect(fake_connector)
          .to receive(:is_a?)
          .with(BaseConnector)
        DirectPageAccessCrawler.new(fake_connector)
      end

    end

  end

  describe 'fetching product nodes' do

    it 'should fetch product nodes from a CSV file' do
      expect(CSVFeedParser).to receive(:fetch_nodes)
        .with('foo').once
      crawler.fetch_product_nodes('foo')
    end

    it 'should assign fetched product nodes to an attr' do
      expect(crawler.nodes).to be_nil
      csv = "#{Rails.root}/spec/fixtures/CSVs/sample_nodes.csv"
      crawler.fetch_product_nodes(csv)
      expect(crawler.nodes).to_not be_nil
    end

  end

  describe 'processing' do

    it 'should iterate through listing nodes' do
      listings = create_list(:listing, 3)
      expect(connector)
        .to receive(:process_listing)
        .with(nodes.first, 0)
      subject.process_listings(nodes)
    end

  end

end
