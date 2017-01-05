require 'rake'
rake = Rake.application
rake.init
rake.load_rakefile

file_path = 'lib/menards_skus.csv'
nodes = CSVFeedParser.fetch_menards_skus(file_path)
connector = Menards.new(PoltergeistCrawler.new)
connector.process_listings(nodes)

