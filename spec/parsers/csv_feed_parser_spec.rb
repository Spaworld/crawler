require 'rails_helper'

RSpec.describe CSVFeedParser do

  let(:file_path) { 'spec/fixtures/sample_skus.csv' }

  it 'should return a space-delim string of skus' do
    expect(CSVFeedParser.fetch_skus(file_path))
      .to eq('foo bar baz')
  end

end
