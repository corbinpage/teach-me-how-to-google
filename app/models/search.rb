#require 'open-url'
#require 'nokogiri'
require 'active_support/core_ext/string/inflections'

class Search < ActiveRecord::Base
	belongs_to :session, dependent: :destroy

	@session
	@topic_hash

	def perform_search

		callId = '004839866588995572534%3Ak4mrucdwo6c'
		key = 'AIzaSyAO6afXroTZPD6lp3cui_w8AOh1Nv0h6Wo'

		uri = URI.parse('https://www.googleapis.com/customsearch/v1?q=' + uri_substitute(self.search_text) + '&cx=' + callId + '&key='+key)
		json_response = Net::HTTP.get_response(uri) # get_response takes an URI object

		self.status = json_response.code
		parse_search(json_response.body)

	end

	def perform_google_search(session, topic_hash)
		@topic_hash = topic_hash
		@session = session
		@result = Result.new

		if !are_search_terms_correct?
			self.status = "Off Topic"
			@result[:search_id] = self.id
			@result[:status] = "false"
			@result[:error] = "Off Topic"
			@result.save
		else
			perform_search
			self.step = self.step.to_i + 1
			self.status = "Success!"
		end

		self.save
	end

private
def are_search_terms_correct?()
	expected_search_text = @topic_hash["text_#{self.search_num.to_s}"]

	case self.step.to_i
	when 0
# Basic keyword matching
self.search_text.match(/\b#{@topic_hash["name"]}\b/i) ||
self.search_text.match(/\b#{@topic_hash["name"].pluralize}\b/i)
when 1
# Use a -dash to exclude certain terms
(
 self.search_text.match(/\b#{@topic_hash["name"]}\b/i) ||
 self.search_text.match(/\b#{@topic_hash["name"].pluralize}\b/i)
 ) && 
self.search_text.match(/-\w/)
when 2
#Exact Phrase - Use Quotes
(
 self.search_text.match(/\b#{@topic_hash["name"]}\b/i) ||
 self.search_text.match(/\b#{@topic_hash["name"].pluralize}\b/i)
 ) && 
self.search_text.match(/['"](\w+)['"]/) && self.search_text.match(/#{@topic_hash["name"]}/)
when 3
# Site specific
(
 self.search_text.match(/\b#{@topic_hash["name"]}\b/i) ||
 self.search_text.match(/\b#{@topic_hash["name"].pluralize}\b/i)
 ) && 
self.search_text.match(/site:\w/) && self.search_text.match(/#{@topic_hash["name"]}/)
when 4
# Filetype specific
(
 self.search_text.match(/\b#{@topic_hash["name"]}\b/i) ||
 self.search_text.match(/\b#{@topic_hash["name"].pluralize}\b/i)
 ) && 
self.search_text.match(/filetype:/) && self.search_text.match(/#{@topic_hash["name"]}/)
when 5
	false
else
	false
end

end

def parse_search(body)
	titles = []
	links = []
	displayLinks = []
	snippets = []

	data = JSON.parse(body)
	items = data["items"]
	#puts data.inspect

	items.length.times do |i|
		result = Result.new()
		result[:search_id] = self.id
		result[:status] = "true"
		result[:search_info_string] = data["searchInformation"].inspect
		result[:item_titles] = items[i]["title"]
		result[:item_links] = items[i]["link"]
		result[:item_display_links] = items[i]["displayLink"]
		result[:item_snippets] = items[i]["snippet"]
		result[:custom1] = gamify(result)
		#puts "|||" + result[:custom1]
		result.save
	end
end

def gamify(result)
		category = false

		category = !!result[:item_snippets].match(/\banimal(s?)\b|\bcat(s?)\b/)

		if !category
			category = !!result[:item_titles].match(/\banimal(s?)\b|\bcat(s?)\b/)
		end

		if !category
			category = !!result[:item_display_links].match(/animal|cat/)
		end

		return category ? "green" : "red"
end

def uri_substitute(search_string)
	search_string.gsub(/\s/,'+').gsub(/"/,"%22")
end

end
