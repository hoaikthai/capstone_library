class UsersController < ApplicationController

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
    	login @user
    	flash[:success] = "Welcome to Capstone Library!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, 
      	:password_confirmation, :birthday, :address)
    end

end
