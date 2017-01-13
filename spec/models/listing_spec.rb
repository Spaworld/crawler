require 'rails_helper'

RSpec.describe Listing, type: :model do

  it { should validate_presence_of(:sku) }

  it 'should have vendors' do
    expect(Listing::VENDORS)
      .to_not be_nil
  end

  describe 'appending vendor attributes' do

    before do
      @listing = create(:listing, sku: '123')
      @attr_hash = {
        vendor:       'hd',
        vendor_id:    '12312312',
        vendor_sku:   '123',
        vendor_url:   Faker::Internet.url,
        vendor_title: Faker::Commerce.product_name,
        vendor_price: Faker::Commerce.price }
    end

    context 'when listing exists' do

      it 'should update listing vendor attrs' do
        Listing.append_vendor_attrs(@listing.sku, @attr_hash)
        expect(Listing.last[:vendors][:hd]).to_not be_empty
        expect(Listing.find_by(sku: @listing.sku).vendors[:hd])
          .to_not be_nil
      end

      it 'should update listings\'s vendor attrs' do
        expect {
          Listing.append_vendor_attrs(@listing.sku, @attr_hash)
        }.to change {
          @listing.reload.vendors }
      end

      it 'should update vendor_id attr' do
        listing = create(:listing, :with_menards_url)
        expect {
          Listing.append_hd_url(listing.sku, @attr_hash[:vendor_url])
        }.to change {
          listing.reload.hd_url }
      end

      it 'should not overwite previous vendor_id entries' do
        listing = create(:listing, :with_menards_url)
        Listing.append_hd_url(listing.sku, 'hd')
        expect(listing.reload.hd_url).to_not be_nil
        expect(listing.menards_url).to_not be_nil
      end

    end

  end

  describe 'appending listing urls directly' do

    subject { Listing }

    it { is_expected.to respond_to(:append_hd_url) }
    it { is_expected.to respond_to(:append_wayfair_url) }
    it { is_expected.to respond_to(:append_overstock_url) }
    it { is_expected.to respond_to(:append_build_url) }
    it { is_expected.to respond_to(:append_hmb_url) }
    it { is_expected.to respond_to(:append_houzz_url) }
    it { is_expected.to respond_to(:append_menards_url) }
    it { is_expected.to respond_to(:append_lowes_url) }

    it 'should append vendor url' do
      Listing.append_hd_url('123', 'googogle.com')
      expect(Listing.first.hd_url).to eq('googogle.com')
    end

  end

  describe 'helper methods' do

    it 'should construct a node hash' do
      listing = create(:listing, :with_menards_attrs)
      expect(listing.to_node('menards')).to eq(
        Hash[listing.sku, listing.vendors[:menards][:vendor_id]]
      )
    end

  end

end
