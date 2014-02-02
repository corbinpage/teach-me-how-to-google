class SessionController < ApplicationController
	@session
	@search
	@result


	def new
	end

	def create
		@session = Session.new(:ip => 'default',:name => 'default',:start_time => Time.now) #possibly move to Session.initialize method
		#Possibly move to Session.initialize method (I couldn't get it working)

		@session.save
		@session = Session.last

		@search = Search.new(:step => 1, :search_num => 1, :search_text => params[:searchText], :session_id => @session[:id])
		#Possibly move to Search.initialize method (I couldn't get it working)
		@search.save

		redirect_to @session
	end

	def add
		@session = Session.find(params[:id])
		old_search = Search.where("session_id = ?", @session[:id]).last

		@search = increment_search(params[:searchText], old_search)
	
		@search.save

		redirect_to @session
	end

	def show
		@session = Session.find(params[:id])
		@search = Search.where("session_id = ?", params[:id]).last
		@result = @search.perform_search()
	end

	def index
	 	#@search = Search.new
	end

	private
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
end
