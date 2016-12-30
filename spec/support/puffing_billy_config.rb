Billy.configure do |c|
  c.cache         = true
  c.persist_cache = true
  c.cache_path    = 'spec/fixtures/billy_cache'
  c.non_whitelisted_requests_disabled = false
  c.non_whitelisted_requests_disabled = true
end
