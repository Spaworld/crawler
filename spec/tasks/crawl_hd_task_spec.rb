require 'rails_helper'

RSpec.describe "crawl:hd", type: :rake do

  before do
    @connector = instance_double(HomeDepotConnector)
    allow(HomeDepotConnector)
      .to receive(:new).and_return(@connector)
  end

  it 'should generate an array of skus arg' do
    expect(@connector)
      .to receive(:process_listings)
    subject.execute('123 123 123')
  end

  it 'should handle empty skus string injection' do
    allow(@connector)
      .to receive(:process_listings)
    expect { subject.execute }.to_not raise_error
  end

end
