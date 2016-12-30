require 'csv'

# fetches skus from a
# CSV file and returns
# a space-delim string
class CSVFeedParser

  def self.fetch_skus(file)
   skus = Array.new
    CSV.foreach(file) do |row|
      skus.push(row.first)
    end
    skus
  end

  def self.stringify_skus(skus)
    skus.join(' ')
  end

end
