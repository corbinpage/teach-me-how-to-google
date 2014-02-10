class SessionController < ApplicationController
	@session
	@search
	@result
	@step_hash


	def new
		session_topic = "jaguar" # Hardcoded for now

		yaml_text = YAML.load_file('/Users/corbinpage/zdev/teach-me-how-to-google/lib/assets/steps.yaml')
		@topic_array = yaml_text["steps"][session_topic]
		new_step = last_search["step"].to_i + 1

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

		@search = process_search(params[:searchText], old_search)
	


		@search.save

		redirect_to @session
	end

	def show
		@session = Session.find(params[:id])
		@search = Search.where("session_id = ?", params[:id]).last
		@step_hash = get_step_text(@search)
		@result = @search.perform_search()
		puts @step_hash.inspect
	end

	def index
	 	#@search = Search.new
	end

	private
		def get_step_text(last_search)
			session_topic = "jaguar" # Hardcoed for now
			yaml_text = YAML.load_file('/Users/corbinpage/zdev/teach-me-how-to-google/lib/assets/steps.yaml')
			@topic_array = yaml_text["steps"][session_topic]
			new_step = last_search["step"].to_i + 1

			step_text = @topic_array["text_#{new_step}"]
			warn_text = @topic_array["warn_#{new_step}"]

			@step_hash = {
				:text => step_text,
				:warn => warn_text
			}

			return @step_hash
		end


		def process_search(search_text=nil, old_search)
			search = Search.new(
				{
					:step => old_search[:step].to_i + 1,
					:search_num => old_search[:search_num] + 1,
					:search_text => search_text.strip,
					:session_id => old_search[:session_id]
				}
			)
			return search
		end	

		def check_search_terms(search)
			expected_search_text = @step_hash["steps"][session_topic]["text_#{old_search[:search_num].to_s}"]
			
			case search[:search_num]
			when 1
				search[:search_num].match(expected_search_text)
			when 2
				search[:search_num].match(expected_search_text)
			when 3
				search[:search_num].match(expected_search_text)
			when 4
				search[:search_num].match(expected_search_text)
			when 5
				search[:search_num].match(expected_search_text)
			when 6
				search[:search_num].match(expected_search_text)
			when 7
				search[:search_num].match(expected_search_text)
			else
				#Possibly throw an error here
				return false
			end
		end


end
