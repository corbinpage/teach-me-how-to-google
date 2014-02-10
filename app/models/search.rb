#require 'open-url'
#require 'nokogiri'

class Search < ActiveRecord::Base
  belongs_to :session, dependent: :destroy

	def perform_search
		callId = '004839866588995572534%3Ak4mrucdwo6c'
		key = 'AIzaSyAO6afXroTZPD6lp3cui_w8AOh1Nv0h6Wo'

		uri = URI.parse('https://www.googleapis.com/customsearch/v1?q=' + self.search_text.gsub(/\s/,'+') + '&cx=' + callId + '&key='+key)
		json_response = Net::HTTP.get_response(uri) # get_response takes an URI object

		self.status = json_response.code
		result = parse_search(json_response.body)

		self.save

		return result
	end

	def format
		return "{id: #{@id}, session_id: #{@session_id}, step: #{@step}, search_num: #{@search_num}, search_text: #{@search_text}, status: #{@status}}"
	end

	private
		def parse_search(body)
			titles = Array.new
			links = Array.new
			displayLinks = Array.new
			snippets = Array.new

			data = JSON.parse(body)
			items = data["items"]



			if items
				items.length.times do |i|
					titles << items[i]["title"]
					links << items[i]["link"]
					displayLinks << items[i]["displayLink"]
					snippets << items[i]["snippet"]
				end
			end

			result = {
				searchInfo: data["searchInformation"],
				item_titles: titles,
				item_links: links,
				item_display_links: displayLinks,
				item_snippets: snippets,
			}

			result = gamify(result)

			puts result.inspect

			return result
		end

		def gamify(result)
			compare = 'http://www.jaguarusa.com/'

			match = result[:item_links].index{|x| x==compare}

			result[:match] = match ? match : false

			return result
		end
end
