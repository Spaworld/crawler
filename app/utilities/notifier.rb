class Notifier
  class << self

    def output_process_info(node, index)
      puts "pid: #{index} | sku: #{node.sku} | id :#{node.id}\n"
    end

    def raise_invalid_node
      puts 'Invalid Node'
    end

    def raise_data_exists
      puts 'Data present'
    end

    def raise_page_not_found
      puts 'Page not found'
    end

  end

end
