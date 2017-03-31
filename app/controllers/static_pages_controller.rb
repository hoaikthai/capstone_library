class StaticPagesController < ApplicationController
  def home
  	if @user = current_user
  		if @user.role == "user"
		  	@borrowings = @user.borrowings
		  	@books = Array.new
		  	@borrowings.each { |b| @books << Book.find_by(id: b.book_id) }
		  else
		  	@borrowings = Borrowing.all.map{ |b| b if !b.request.nil? }.compact
		  	@books = @users = Array.new
		  	@borrowings.each do |b|
		  		@books << Book.find_by(id: b.book_id)
		  		@users << User.find_by(id: b.user_id)
		  	end
		  end
  	end
  end
end
