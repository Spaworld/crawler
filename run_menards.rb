# require 'rake'
# rake = Rake.application
# rake.init
# rake.load_rakefile

csv = 'lib/menards_skus.csv'
# nodes = CSVFeedParser.fetch_menards_skus(file_path)
# connector = Menards.new(PoltergeistCrawler.new)
# connector.process_listings(nodes)
#
connector = Menards.new(PoltergeistCrawler.new)
crawler = DirectPageAccessCrawler.new(connector)
csv = 'lib/menards_skus.csv'
crawler.fetch_product_nodes(csv)
crawler.process_listings

