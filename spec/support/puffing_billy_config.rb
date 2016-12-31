Billy.configure do |c|
  c.cache         = true
  # c.cache_request_headers = true
  c.persist_cache = true
  c.cache_path    = 'spec/fixtures/billy_cache'
  c.non_whitelisted_requests_disabled = false
  c.non_successful_cache_disabled = false
  c.ignore_params = ['http://zn_42v6draxyafsjmv-homedepot.siteintercept.qualtrics.com/WRSiteInterceptEngine']
end
