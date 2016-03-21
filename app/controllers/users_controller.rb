class UsersController < ApplicationController
	before_action :logged_in_user, only: [:update, :edit, :destroy,
											:following, :followers]

	def new
		@user = User.new
	end

	def show
		@user = User.find params[:id]
		@entries = @user.entries.paginate page: params[:page]
	end

	def create
		@user = User.new user_params
		if @user.save
			flash[:success] = "Welcome to sample app"
			redirect_to root_url
		else
			render "new"
		end
	end

	def index
		@users = User.paginate page: params[:page]
	end

	def following
		@title = "Following"
		@user = User.find params[:id]
		@users = @user.following.paginate page: params[:page]
		render "show_follow"
	end

	def followers
		@title = "Followers"
		@user = User.find params[:id]
		@users = @user.followers.paginate page: params[:page]
		render "show_follow"
	end

	def logged_in_user
		unless logged_in?
			flash[:danger] = "Please log in"
			redirect_to login_url
		end
	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password,
				:password_confirmation)
		end
end
