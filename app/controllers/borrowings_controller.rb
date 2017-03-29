class BorrowingsController < ApplicationController

	def create
		@user = User.find(params[:user_id])
		@book = Book.find(params[:book_id])
		@user.update_attribute(:number_of_borrowed_books, @user.number_of_borrowed_books+1)
		@book.update_attribute(:availability, @book.availability-1)
		@borrowing = Borrowing.create(user_id: params[:user_id], book_id: params[:book_id])
		respond_to do |format|
			format.html { redirect_to @book }
			format.js
		end
	end

	def edit
	end

	def update
	end

	def destroy
		@user = User.find(params[:user_id])
		@book = Book.find(params[:book_id])
		@user.update_attribute(:number_of_borrowed_books, @user.number_of_borrowed_books-1)
		@book.update_attribute(:availability, @book.availability+1)
		Borrowing.find(params[:id]).delete
		respond_to do |format|
			format.html { redirect_to @book }
			format.js
		end
	end

end
