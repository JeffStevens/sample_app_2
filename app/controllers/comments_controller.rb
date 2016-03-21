class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]

	def new
		@entry = Entry.find params[:entry_id]
		@comment = current_user.comments.build if logged_in?
		@comments = @entry.comments.paginate page: params[:page] 
	end

	def create
		@comment = current_user.comments.build comment_params
		if @comment.save
			flash[:success] = "Commented!"
			redirect_to request.referrer || root_url
		end
	end

	def destroy
		@comment = Comment.find(params[:id]).destroy
		redirect_to request.referrer || root_url
	end

	private
		def comment_params
			params.require(:comment).permit(:content, :entry_id)
		end
end
