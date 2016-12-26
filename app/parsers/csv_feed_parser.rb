require 'csv'
class CSVFeedParser

  attr_accessor :skus

  def initialize
    @skus = Array.new
  end

  def fetch_skus(file)
    CSV.foreach(file) do |row|
      @skus.push(row)
    end
  end

end
