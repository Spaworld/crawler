class MenardsCrawler

  include Sidekiq::Worker

  # def perform(ids)
  #   connector = Menards.new(PoltergeistCrawler.new)
  #   connector.process_listings(ids)
  # end
  #
  def perform(id)
    c = Menards.new(PoltergeistCrawler.new)
    c.visit_product_page(id)
    c.fetch_menards_skus(id)
    Listing.append_menards_url(c.listing_attrs[:vendor_sku],
                               c.listing_attrs[:vendor_url])
  end

end
