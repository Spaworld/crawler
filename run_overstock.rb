csv = 'lib/menards_skus.csv'
connector = Menards.new(PoltergeistCrawler.new)
crawler = DirectPageAccessCrawler.new(connector)
csv = 'lib/menards_skus.csv'
crawler.fetch_product_nodes(csv)
crawler.process_listings
