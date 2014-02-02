require 'net/http'

url = 'https://www.googleapis.com/customsearch/v1?q=apple&cx=004839866588995572534%3Ak4mrucdwo6c&key=AIzaSyAO6afXroTZPD6lp3cui_w8AOh1Nv0h6Wo'
resp = Net::HTTP.get_response(URI.parse(url)) # get_response takes an URI object

data = resp.body

puts data