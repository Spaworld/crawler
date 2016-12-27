require 'csv'

# fetches skus from a csv file
class CSVFeedParser

  attr_reader :skus

  def initialize
    @skus = Array.new
  end

  def fetch_skus(file)
    CSV.foreach(file) do |row|
      @skus.push(row)
    end
  end

end
