csv = 'lib/hd_skus.csv'
connector = HomeDepot.new(PoltergeistCrawler.new)
crawler = DirectPageAccessCrawler.new(connector)
crawler.fetch_product_nodes(csv)
crawler.process_listings

