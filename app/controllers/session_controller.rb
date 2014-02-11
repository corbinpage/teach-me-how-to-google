class SessionController < ApplicationController
	@session
	@search
	@result
	@topic_hash
	#@recent_search_text

	def new
		session_topic = "jaguar" # Hardcoded for now
		yaml_text = YAML.load_file('lib/assets/steps.yaml')
		@topic_hash = yaml_text["steps"][session_topic]
		#puts @topic_array.inspect
	end

	def create
		@session = Session.new(:custom1 => 'jaguar', :ip => 'default',:name => 'default',:start_time => Time.now) #possibly move to Session.initialize method
		#Possibly move to Session.initialize method (I couldn't get it working)

		@session.save
		@session = Session.last

		@search = Search.new(:status => "Pending", :step => 0, :search_num => 0, :search_text => params[:searchText], :session_id => @session[:id])
		#Possibly move to Search.initialize method (I couldn't get it working)
		@search.save

		redirect_to @session
	end

	def add
		@session = Session.find(params[:id])
		old_search = Search.where("session_id = ?", @session[:id]).last
		@search = Search.new(:status => "Pending",
												 :search_text => params[:searchText],
												 :session_id => @session[:id],
												 :step => old_search[:step],
												 :search_num => old_search[:search_num]
												)
		@search.save

		redirect_to @session
	end

	def show
		@session = Session.find(params[:id])
		@search = Search.where("session_id = ?", @session[:id]).last
		@result = {}

		yaml_text = YAML.load_file('lib/assets/steps.yaml')
		@topic_hash = yaml_text["steps"][@session[:custom1]]

		@search.prepare_search!(@session, @topic_hash)

		if !@search.are_search_terms_correct?
			@search[:status] = "Off Topic"
			@result[:status] = "Off Topic"
		else
			@result = @search.perform_search(@session, @topic_hash)
			@search[:step] = @search[:step].to_i + 1
			@search[:status] = "Success!"
		end
		puts "|||"+ @search.inspect
		@search.save

	end

end
