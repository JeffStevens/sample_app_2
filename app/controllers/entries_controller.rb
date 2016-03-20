class EntriesController < ApplicationController
	def create
		if @micropost.save
			flash[:success] = "Entry created!"
			redirect_to root_url
		end
	end

	def destroy

	end
end
