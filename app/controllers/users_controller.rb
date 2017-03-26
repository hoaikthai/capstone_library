class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :edit, :update]
	before_action :correct_user, only: [:edit, :update]

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
	end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "user"
    if @user.save
    	@user.send_activation_email
    	flash[:info] = "Please check your email for account activation"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  		flash[:success] = "Profile updated"
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
      	:password_confirmation, :birthday, :address)
    end

    def logged_in_user
    	unless logged_in?
    		store_location
    		flash[:danger] = "Please log in to continue"
    		redirect_to login_url
    	end
    end

    def correct_user
    	@user = User.find(params[:id])
    	redirect_to(root_url) unless current_user?(@user)
    end

end
