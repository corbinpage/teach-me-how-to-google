class SearchController < ApplicationController
	def new
		@search = Search.new
	end

	def add
		debugger
		@session = Session.find(params[:id])
		old_search = Search.find_by session_id: @session[:id]



		@search = Search.new(
			{
		  	 	:session_id => old_search[:session_id],
		  	 	:step => old_search[:step] + 1,
		  	 	:search_num => old_search[:search_num] + 1,
		  	 	:search_text => params[:searchText],
		  	 	:status => "OK"
	  	 	}
	  	 )

		@search.save
		redirect_to @session
	end

	def create
		@session = setup_initial_session
		@search = Search.new()
		@search = setup_initial_search(params[:searchText],@session[:id])
		#logger.debug "|~~HERE~~~#{@search.format}~~~~~#{@session[:id]}"
		

		if @search.save
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

		def setup_initial_search(search_text=nil, session_id=nil)
			search = Search.new(
				{
					:step => 1,
					:search_num => 1,
					:search_text => search_text,
					:session_id => session_id,
					:status => "okie doke"
				}
			)
			return search
		end
end
