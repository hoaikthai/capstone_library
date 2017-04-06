class StaticPagesController < ApplicationController
  def home
  	if @user = current_user
  		if @user.role == "user"
		  	@borrowings = @user.borrowings
		  else
		  	@borrowings = Borrowing.all.map{ |b| b if !b.request.nil? }.compact
		  end
  	end
  end
end
