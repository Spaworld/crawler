require 'rails_helper'

RSpec.describe Listing, type: :model do

  it { should validate_presence_of(:sku) }

  it 'should validate channel url format' do
    expect{
      create(:listing, hd_url: 'foo')
    }.to raise_error(
      ActiveRecord::RecordInvalid)
  end

  describe 'CHANNELS' do

    let (:subject) { Listing }

    it { is_expected.to be_const_defined(:CHANNELS) }

    it 'should include home depot' do
      expect(Listing::CHANNELS).to include('hd')
    end

    it 'should include menards' do
      expect(Listing::CHANNELS).to include('menards')
    end

    it 'should include overstock' do
      expect(Listing::CHANNELS).to include('overstock')
    end

    it 'should include lowes' do
      expect(Listing::CHANNELS).to include('lowes')
    end

    it 'should include build' do
      expect(Listing::CHANNELS).to include('build')
    end

    it 'should include hmb' do
      expect(Listing::CHANNELS).to include('hmb')
    end

    it 'should include wayfair' do
      expect(Listing::CHANNELS).to include('wayfair')
    end

    it 'should include wayfair' do
      expect(Listing::CHANNELS).to include('houzz')
    end

  end

  describe 'dynamic channel url appending' do

    let (:subject) { Listing }

    it { is_expected.to respond_to(:append_hd_url) }
    it { is_expected.to respond_to(:append_menards_url) }
    it { is_expected.to respond_to(:append_overstock_url) }
    it { is_expected.to respond_to(:append_lowes_url) }
    it { is_expected.to respond_to(:append_build_url) }
    it { is_expected.to respond_to(:append_hmb_url) }
    it { is_expected.to respond_to(:append_wayfair_url) }
    it { is_expected.to respond_to(:append_houzz_url) }

  end

  it 'should update listing with channel url' do
    listing = create(:listing)
    Listing.append_hd_url('http://abc.com', listing.sku)
    listing.reload
    expect(listing.hd_url).to eq('http://abc.com')
  end

  it 'should return available channel urls' do
    listing = build(:listing, hd_url: 'http://foo.com')
    expect(listing.available_channel_urls)
      .to include('http://foo.com')
  end

end
