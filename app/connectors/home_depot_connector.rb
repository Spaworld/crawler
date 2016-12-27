# Instance of PoltergeistCrawler for driving
# through HomeDepot.com
class HomeDepotConnector < PoltergeistCrawler

  def process_skus(skus)
    skus.each do |sku|
      get_listing_page(sku)
      append_url_to_listing(sku)
    end
  end

  def get_listing_page(sku)
    visit("http://www.homedepot.com/s/#{sku}")
  end

  def append_url_to_listing(sku)
    url = page.current_url
    Listing.append_hd_url(url, sku)
  end

end
