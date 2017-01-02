namespace :crawl do

  desc 'crawls home depot listings'
  task :hd, [:skus] => [:environment] do |task, args|
    skus_array = args[:skus].split(' ').flatten
    connector  = HomeDepot.new(PoltergeistCrawler.new)
    connector.process_listings(skus_array)
  end

end
