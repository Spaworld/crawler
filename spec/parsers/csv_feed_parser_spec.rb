require 'rails_helper'

RSpec.describe CSVFeedParser do

  let(:file_path) { 'spec/fixtures/sample_skus.csv' }

  it 'returns a list of target SKUS' do
    subject.fetch_skus(file_path)
    expect(subject.skus)
      .to eq([['foo'],['bar'],['baz']])
  end

end
