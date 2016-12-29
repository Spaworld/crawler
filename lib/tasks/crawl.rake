namespace :crawl do

  desc 'crawls home depot listings'
  task :hd, [:skus] => [:environment] do |task, skus|
    skus_array = skus.split(' ')
    connector  = HomeDepotConnector.new
    connector.process_listings(skus_array)
  end

end
