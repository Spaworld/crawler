Billy.configure do |c|
  c.cache         = true
  c.cache_request_headers = true
  c.persist_cache = true
  c.cache_path    = 'spec/fixtures/billy_cache'
  c.non_whitelisted_requests_disabled = true
  c.ignore_params = ['http://www.homedepot.com/']
  c.whitelist     = ['http://www.homedepot.com/']
end
