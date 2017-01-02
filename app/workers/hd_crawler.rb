class HDCrawler

  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(skus_array)
    connector = HomeDepot.new(PoltergeistCrawler.new)
    connector.process_listings(skus_array)
  end

  sidekiq_retry_in do |count|
    10 * (count + 1)
  end

  sidekiq_retries_exhausted do |msg, e|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

end
