class SessionController < ApplicationController
	def new
	end

	def show
		@session = Session.find(params[:id])
	end

end
