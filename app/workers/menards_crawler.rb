class MenardsCrawler

  include Sidekiq::Worker

  def perform(ids)
    connector = Menards.new(PoltergeistCrawler.new)
    connector.process_listings(ids)
  end

end
