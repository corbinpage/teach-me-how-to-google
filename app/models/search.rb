class Search < ActiveRecord::Base
  belongs_to :session, dependent: :destroy

	def new
	end

	def format
		return "{id: #{@id}, session_id: #{@session_id}, step: #{@step}, search_num: #{@search_num}, search_text: #{@search_text}, status: #{@status}}"
	end

end
