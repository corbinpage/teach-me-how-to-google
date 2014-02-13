class SessionController < ApplicationController
	@session
	@search
	@result
	@topic_hash

	def new
		session_topic = "jaguar" # Hardcoded for now
		yaml_text = YAML.load_file('lib/assets/steps.yaml')
		@topic_hash = yaml_text["steps"][session_topic]
		#puts @topic_array.inspect
	end

	def create
		@session = Session.new(custom1: 'jaguar',ip: 'default',name: 'default',start_time: Time.now)
		#Possibly move to Session.initialize method (I couldn't get it working)
		@session.save
		@session = Session.last

		@search = Search.new(:status => "Pending", :step => 0, :search_num => 0, :search_text => params[:searchText], :session_id => @session[:id])
		#Possibly move to Search.initialize method (I couldn't get it working)
		@search.save

		yaml_text = YAML.load_file('lib/assets/steps.yaml')
		@topic_hash = yaml_text["steps"][@session[:custom1]]
		@search.perform_google_search(@session, @topic_hash)

		redirect_to @session
	end

	def add
		@session = Session.find(params[:id])
		old_search = Search.where("session_id = ?", @session[:id]).last
		@search = Search.new(:status => "Pending",
												 :search_text => params[:searchText],
												 :session_id => @session[:id],
												 :step => old_search[:step],
												 :search_num => old_search[:search_num].to_i
												)
		@search.save

		yaml_text = YAML.load_file('lib/assets/steps.yaml')
		@topic_hash = yaml_text["steps"][@session[:custom1]]
		@search.perform_google_search(@session, @topic_hash)

		redirect_to @session
	end

	def show
		@session = Session.find(params[:id])
		@search = Search.where("session_id = ?", @session[:id]).last
		@result = Result.where("search_id = ?", @search[:id])

		yaml_text = YAML.load_file('lib/assets/steps.yaml')
		@topic_hash = yaml_text["steps"][@session[:custom1]]

		puts "||||HERE||||"
		puts "||||RESULT||||"
		puts @result.inspect

	end

end
