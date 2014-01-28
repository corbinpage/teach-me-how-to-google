class SearchController < ApplicationController
	def new
	end


	def create
		@session = setup_initial_session
		@search = Search.new()
		@search = setup_initial_search(params[:searchText],@session[:id])
		#logger.debug "|~~HERE~~~#{@search.format}~~~~~#{@session[:id]}"

		if perform_search(@search)
			redirect_to @session
		else
			redirect('session/new')
		end
	end

	def add
		@session = Session.find(params[:id])
		old_search = Search.where("session_id = ?", @session[:id]).last

		@search = increment_search(params[:searchText], old_search)
		perform_search(@search)
	
		if perform_search(@search)
			redirect_to @session
		else
			redirect('session/new')
		end
	end


	def show
		@session = Session.find([:id])
		@search = Search.find(params[:id])
		logger.debug "~~~~~#{@search}~~~~~#{@session}"
	end

	def index
	 	#@search = Search.new
	end

	private
		def perform_search(search)
			# Insert Google Search here
			search.save
		end


		def setup_initial_session
			session = Session.new(
				{
					:ip => 'default',
					:name => 'default',
					:start_time => Time.now
				}
			)
			session.save!
			return session
		end

		def increment_search(search_text=nil, old_search)
			search = Search.new(
				{
					:step => old_search[:step].to_i + 1,
					:search_num => old_search[:search_num] + 1,
					:search_text => search_text,
					:session_id => old_search[:session_id]
				}
			)
			return search
		end

		def setup_initial_search(search_text=nil, session_id=nil)
			search = Search.new(
				{
					:step => 1,
					:search_num => 1,
					:search_text => search_text,
					:session_id => session_id
				}
			)
			return search
		end
end
