Billy.configure do |c|
  c.cache         = true
  c.cache_request_headers = true
  c.persist_cache = true
  c.cache_path    = 'spec/fixtures/billy_cache'
  # c.non_whitelisted_requests_disabled = true
  c.ignore_params = ['http://www.homedepot.com/',
                     'http://www.menards.com/_Incapsula_Resource',
                     'http://www.menards.com/main/search.html']
  c.whitelist     = ['http://www.homedepot.com/',
                     'http://www.menards.com/main/home.html',
                     'http://www.menards.com/main/search.html',
                     'http://www.menards.com/sitemap/sitemap.xml',
                     'http://www.menards.com/sitemap/sitemap.xml']

  c.path_blacklist= [
    'http://www.menards.com/_Incapsula_Resource']
end
