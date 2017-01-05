require 'rake'
rake = Rake.application
rake.init
rake.load_rakefile

file_path = 'lib/hd_skus.csv'
nodes = CSVFeedParser.fetch_nodes(file_path)
connector = HomeDepot.new(PoltergeistCrawler.new)
connector.process_listings(nodes)
