class OverstockCrawler

  def get_nodes
    file_path = 'lib/overstock_skus.csv'
    @nodes = CSVFeedParser.fetch_nodes(file_path)
  end

  def remove_node(node = nil)
    return if @nodes.nil?
    @nodes.reject! { |n| n[0] == node }
  end

  def kill_node(array, id)
    array.reject! { |n| n[0] == id }
  end

  def process_listings(nodes = @nodes)
    begin
      nodes.each_with_index do |node, index|
        id = node[0]
        sku = node[1]
        if id == '#N/A'
          puts '>>> no ID'
          next
        end

        puts "=== starting id: #{id} \
      | sku: #{sku} \
      | iteration: #{index} \
      | remaining_nodes: #{@nodes.count}"

        puts '>>> data exists' && next if Listing.data_present?(sku, 'overstock')
        connector = Overstock.new(PoltergeistCrawler.new)
        if (index + 1)  % 20 == 0
          connector.driver.page.driver.browser.restart
        end
        connector.process_listing(node, index)
        kill_node(@nodes, id)
      end
    rescue Exception => e
      puts ">>> caught one! #{e}"
          sleep(rand(1..3.333))
          process_listings(nodes)
    end
  end

end
c = OverstockCrawler.new
c.get_nodes
c.process_listings


