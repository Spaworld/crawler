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

end
