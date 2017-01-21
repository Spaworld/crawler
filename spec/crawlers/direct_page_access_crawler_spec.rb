require 'rails_helper'

RSpec.describe DirectPageAccessCrawler do

  let(:subject)   { DirectPageAccessCrawler.new(connector) }
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

    end # driver validation

  end  # init

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

  end # fetching nodes

  describe 'processing' do

    before do
      allow(connector).to receive(:fetch_product_attributes)
      allow(connector).to receive(:store_product_attributes)
      allow(connector).to receive(:visit_product_page)
    end

    it 'should iterate through listing nodes' do
      listings = create_list(:listing, 1, :with_menards_attrs)
      nodes = [listings.first.to_node('menards')]
      expect(connector)
        .to receive(:process_listing)
        .with(nodes.first)
      crawler.process_listings(nodes)
    end

    it 'should output process details' do
      listings = create_list(:listing, 1, :with_menards_attrs)
      nodes = [listings.first.to_node('menards')]
      expect(crawler)
        .to receive(:output_process_info)
        .with(nodes.first, 0)
      crawler.process_listings(nodes)
    end

    it 'should call #output_process_info on Notifier' do
      node = OpenStruct.new(id: '1', sku: '2')
      nodes = [node]
      expect(Notifier).to receive(:output_process_info)
        .with(node, 0)
      crawler.process_listings(nodes)
    end

    describe 'dispatching action' do

      context 'when the bulk of 20 nodes is complete' do

        it 'should restart the driver' do
          index = rand(1..9) * 20
          expect(connector)
            .to receive(:restart_driver)
          node = build(:node)
          crawler.send(:dispatch_action, node, index)
        end

        it 'should process listing' do
          expect(connector)
            .to receive(:process_listing)
          node = build(:node)
          crawler.send(:dispatch_action, node, 20)
        end

      end # when bulk of 20 is complete

      describe 'restarting the driver' do

        context 'when index arg is 0' do

          it 'should not restart the driver' do
            expect(connector)
              .to_not receive(:restart_driver)
            node = build(:node)
            crawler.send(:dispatch_action, node, 0)
          end

          it 'should still process listing' do
            node = build(:node)
            expect(connector)
              .to receive(:process_listing)
              .with(node)
              .once
            crawler.send(:dispatch_action, node, 0)
          end

        end # when index arg is 0

        context 'when the index arg is > 1 and is NOT dividable by 20' do

          it 'should restart the driver' do
            expect(connector)
              .to_not receive(:restart_driver)
            node = build(:node)
            index = rand(1...19)
            crawler.send(:dispatch_action, node, index)
          end

          it 'should still process listing' do
            node = build(:node)
            index = rand(1...19)
            expect(connector)
              .to receive(:process_listing)
              .with(node)
              .once
            crawler.send(:dispatch_action, node, index)
          end

        end # when index arg != 0

      end # restarting driver

      it 'should process listing' do
        node = OpenStruct.new(id: '1', sku: '2')
        expect(connector)
          .to receive(:process_listing)
          .with(node)
        crawler.send(:dispatch_action, node, rand(0..21))
      end

    end # dispatching action

    describe 'node validation' do

      it 'should check if node has "sku" and "id" values' do
        listings = create_list(:listing, 1, :with_menards_attrs)
        node = listings.first.to_node('menards')
        allow(connector).to receive(:fetch_product_attributes)
        allow(connector).to receive(:store_product_attributes)
        expect(crawler)
          .to receive(:invalid_node?)
          .with(node)
          .once
        crawler.process_listings([node])
      end

      context 'when node is invalid' do

        let(:nil_id_node)     { OpenStruct.new(id: '',     sku: '123') }
        let(:valid_node)      { OpenStruct.new(id: '123',  sku: '123') }
        let(:invalid_id_node) { OpenStruct.new(id: '#N/A', sku: '123') }

        it '#invalid_node? should return true' do
          expect(crawler.send(:invalid_node?, nil_id_node))
            .to eq(true)
          expect(crawler.send(:invalid_node?, invalid_id_node))
            .to eq(true)
        end

        describe 'beacuse of an empty id' do

          it 'should identify the invalid node' do
            expect(crawler.send(:invalid_node?, nil_id_node))
              .to be_truthy
          end

          it 'should skip invalid node' do
            nodes = [nil_id_node, valid_node]
            expect(connector)
              .to receive(:process_listing)
              .with(valid_node)
              .once
            crawler.process_listings(nodes)
          end

          it 'should not process invalid node' do
            nodes = [nil_id_node]
            expect(connector)
              .to_not receive(:process_listing)
            crawler.process_listings(nodes)
          end

          it 'should notify of invalid node' do
            nodes = [nil_id_node]
            expect(Notifier)
              .to receive(:raise_invalid_node)
            crawler.process_listings(nodes)
          end

        end # when node.id.nil?

        describe 'because of an invalid id' do

          it 'should identify the invalid node' do
            expect(crawler.send(:invalid_node?,
                                invalid_id_node))
              .to be_truthy
          end

          it 'should skip listing processing for that node' do
            nodes = [invalid_id_node]
            expect(connector)
              .to_not receive(:process_listing)
            crawler.process_listings(nodes)
          end

          it 'should notify of invalid node' do
            nodes = [invalid_id_node]
            expect(Notifier)
              .to receive(:raise_invalid_node)
            crawler.process_listings(nodes)
          end

        end # when node.id is invalid

        describe 'beacuse of an empty sku' do

          let(:empty_sku_node) { OpenStruct.new(id: '#N/A', sku: '') }

          it 'should identify the invalid node' do
            expect(crawler.send(:invalid_node?, empty_sku_node))
              .to be_truthy
          end

          it 'should skip listing processing for that node' do
            nodes = [empty_sku_node]
            expect(connector)
              .to_not receive(:process_listing)
            crawler.process_listings(nodes)
          end

          it 'should notify of invalid node' do
            nodes = [empty_sku_node]
            expect(Notifier)
              .to receive(:raise_invalid_node)
            crawler.process_listings(nodes)
          end

        end # empty sku

      end # invalid node

    end # node validation

    describe 'listing data validation' do

      it 'should check if listing vendor data already exists' do
        listings = create_list(:listing, 1, :with_menards_attrs)
        nodes = [listings.first.to_node('menards')]
        expect(crawler)
          .to receive(:data_exists?)
          .with(nodes.first)
          .once
        crawler.process_listings(nodes)
      end

      context 'when listing vendor data already exists' do

        describe '#data_exists? analyzer' do

          let(:listing) { create(:listing,
                                 :with_menards_attrs,
                                 :with_menards_url) }
          let(:node)    { listing.to_node('menards') }

          it 'should return true' do
            expect(crawler.send(:data_exists?, node))
              .to eq(true)
          end

          it 'should query Listings for existing vendor data' do
            expect(Listing).to receive(:data_present?)
              .with(node.sku, 'menards')
            crawler.send(:data_exists?, node)
          end

          it 'should notify about existing data' do
            nodes = [node]
            expect(Notifier)
              .to receive(:raise_data_exists)
            crawler.process_listings(nodes)
          end

          it 'should identify existing vendor data' do
            expect(crawler.send(:data_exists?, node))
              .to be_truthy
          end

        end # #data_exists?

      end # when listing.vendors data exists

    end # listing data validation

  end # listing processing

end
