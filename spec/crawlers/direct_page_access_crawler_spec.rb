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

    it 'should iterate through stored nodes' do
      csv = "#{Rails.root}/spec/fixtures/CSVs/sample_nodes.csv"
      crawler.fetch_product_nodes(csv)
      expect{ crawler.process_listings }
        .to_not raise_error
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

        describe 'beacuse of an empty id' do

          let(:nil_id_node) { OpenStruct.new(id: '',    sku: '123') }
          let(:valid_node)  { OpenStruct.new(id: '123', sku: '123') }

          it 'should identify the invalid node' do
            expect(crawler.send(:invalid_node?, nil_id_node))
              .to be_truthy
          end

          it 'should skip invalid node' do
            nodes = [nil_id_node, valid_node]
            expect(crawler)
              .to receive(:output_process_info)
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

        end

        describe 'because of an invalid id' do

          let(:invalid_id_node) { OpenStruct.new(id: '#N/A',    sku: '123') }

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

        end

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
        node = listings.first.to_node('menards')
        expect(crawler)
          .to receive(:data_exists?)
          .with(node)
          .once
        crawler.process_listings([node])
      end

      context 'when listing vendor data already exists' do

        let(:listing) { create(:listing,
                               :with_menards_attrs,
                               :with_menards_url) }

        it 'should notify about existing data' do
          nodes = [listing.to_node('menards')]
          expect(Notifier)
            .to receive(:raise_data_exists)
          crawler.process_listings(nodes)
        end

      end # when listing.vendors data exists

    end # listing data validation

  end # listing processing

end
