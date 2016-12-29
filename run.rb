file_path = 'lib/skus.csv'
skus = CSVFeedParser.fetch_skus(file_path)
Rake::Task.crawl.invoke(oskus)
Rake::Task['crawl:hd'].invoke(skus)
