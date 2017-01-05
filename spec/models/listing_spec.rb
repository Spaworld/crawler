require 'rails_helper'

RSpec.describe Listing, type: :model do

  it { should validate_presense_of(:sku) }

  it 'should have vendors' do
    expect(Listing::VENDORS)
      .to_not be_nil
  end


  describe 'appending vendor attributes' do
    pending
    before do
      @attr_hash = {
        vendor:       'hd',
        vendor_id:    '12312312',
        vendor_sku:   '123',
        vendor_url:   Faker::Internet.url,
        vendor_title: Faker::Commerce.product_name,
        vendor_price: Faker::Commerce.price }
      @listing = create(:listing, sku: '123')
    end

    context 'when listing exists' do

      it 'should update listing vendor attrs' do

          Listing.append_vendor_attrs(@listing.sku, @attr_hash)
          expect(Listing.first[:vendors][:hd]).to_not be_empty
      end

    end

  end

  describe 'appending listing urls' do

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

end
