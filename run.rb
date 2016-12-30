require 'rake'
rake = Rake.application
rake.init
rake.load_rakefile

file_path = 'lib/skus.csv'
skus = CSVFeedParser.fetch_skus(file_path)
rake['crawl:hd'].invoke(skus)
