class SearchController < ApplicationController
	def new
	end

	def add
		# START HERE 1-16-2014 -Corbin


		logger.debug "|||||#{@search}"
		@search = Search.new(get_initial_params)

		@search.save
		redirect_to @search
	end

	def create
		@session = setup_initial_session
		@search = Search.new(get_initial_params)
		@search[:session_id] = @session[:id]
		@search.save
		redirect_to @session
		logger.debug "CR~~~~~#{@search}~~~~~#{@session}"
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
	  	session.save
	  	return session
	  end

	  def get_initial_params
	  	search = {
	  	 	:step => 1,
	  	 	:search_num => 1, 
	  	 	:search_text => params[:searchText],
	  	 	:status => "OK"}
	  end
end
