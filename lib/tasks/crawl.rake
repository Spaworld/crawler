namespace :crawl do

  desc 'crawls home depot listings'
  task :hd, [:skus] => [:environment] do |task, args|
    skus_array = args[:skus].split(' ').flatten
    HDCrawler.new.perform(skus_array)
  end

  desc 'crawls menards listings'
  task :menards, [:skus] => [:environment] do |task, args|
    skus_array = args[:skus].split(' ').flatten
    MenardsCrawler.new.perform(skus_array)
  end

end
