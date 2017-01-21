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
  # injected nodes (default: @nodes)
  def process_listings(nodes)
    nodes.each_with_index do |node, index|
      output_process_info(node, index)
      next if invalid_node?(node)
      next if data_exists?(node)
      dispatch_action(node, index)
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
    if Listing.data_present?(node.sku, connector.abbrev)
      Notifier.raise_data_exists
      true
    end
  end

  # returns 'true' if node's
  # 'id' or 'sku' values are
  # - nil
  # - empty
  # - eql?('#N/A')
  def invalid_node?(node)
    node_hash  = node.to_h
    if node_hash.values.any? { |value|
      value.nil? ||
        value.empty? ||
        value == '#N/A' }
      Notifier.raise_invalid_node
      true
    end
  end

  # Outputs process info to STDOUT
  def output_process_info(node, index)
    Notifier.output_process_info(node, index)
  end

  # Dispatches action based on current index param
  # - when != 0 AND % 20, restart_driver
  # - else proceeds with data storing
  def dispatch_action(node, index)
    check_if_restart_required(index)
    connector.process_listing(node)
  end

  private

  # checks if the bulk of 20 pages is complete
  # and restart the driver's browser
  def check_if_restart_required(index)
    return if index.eql?(0)
    connector.restart_driver if index % 20 == 0
  end

end
