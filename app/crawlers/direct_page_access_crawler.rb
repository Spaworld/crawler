# Crawler which accesses
# product pages directly
class DirectPageAccessCrawler

  attr_reader :connector, :nodes

  # Iniits with a specific
  # vendor connector
  def initialize(connector)
    validate_connector_type(connector)
  end

  # Fetches product nodes
  # in a CSV format from
  # a local directory
  def fetch_product_nodes(file_path)
    @nodes = CSVFeedParser.fetch_nodes(file_path)
  end

  # Creates listings from
  # fetched @nodes
  def process_listings(nodes)
    @nodes.each_with_index do |node, index|
      next if data_exists?(node)
      next if nil_id?(node)
      output_process_info(node, index)
      validate_listing(id, sku, index)
      index % 20 == 0 ? connector.restart : connector.process_listing(node, index)
    end
  end

  private

  # Validates connector to be an instance
  # of a BaseConnector superclass
  def validate_connector_type(obj)
    if obj.is_a?(BaseConnector)
      @connector = obj
    else
      raise InvalidConnectorError
    end
  end

  # returns 'true' if listing's vendor
  # data is present
  def data_exists?(node)
    if Listing.data_present?(node[1],
        connector.abbrev)
      Notifier.raise_data_exists
      return true
    end
  end

  # returns 'true' if node's
  # 'id' or 'sku' are missing
  def invalid_node?(node)
    if node[0].nil? || node[1].nil?
      Notifier.raise_invalid_node
      return true
    end
  end

  # Outputs process info to STDOUT
  def output_process_info(node, index)
    Notifier.output_process_info(id, sku, index)
  end

end
