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

  def self.fetch_menards_skus(file_path)
    nodes = {}
    CSV.foreach(file_path) do |row|
      nodes[row[0]] = row[1]
    end
    nodes
  end

  # Parses the file at `file_path`
  # and returns an array of ostruct
  # nodes with keys 'sku' and 'id'
  def self.fetch_nodes(file_path)
    nodes = []
    CSV.foreach(file_path) do |row|
      nodes << OpenStruct.new(id:  row[0],
                              sku: row[1])
    end
    nodes
  end

  def self.export_skus
    path = "#{Rails.root}/lib/export/vendor_data.csv"
    CSV.open(path, 'wb') do |csv|
      csv << [ 'sku',
               'hd_url',        'hd_price',
               'wayfair url',   'wayfair price',
               'menards url',   'menard price',
               'overstock url', 'overstock price',
               'houzz url',     'houzz price',
               'amazon_url',    'amazon_price']

      Listing.all.map do |listing|
        csv << [ listing.sku,
                 listing.vendors[:hd][:url],
                 listing.vendors[:hd][:price],
                 listing.vendors[:wayfair][:url],
                 listing.vendors[:wayfair][:price],
                 listing.vendors[:menards][:url],
                 listing.vendors[:menards][:price],
                 listing.vendors[:overstock][:url],
                 listing.vendors[:overstock][:price],
                 listing.vendors[:houzz][:url],
                 listing.vendors[:houzz][:price],
                 listing.amazon_url, 'N/A']
      end
    end
  end

end
