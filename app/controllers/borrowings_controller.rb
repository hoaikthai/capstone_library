class BorrowingsController < ApplicationController

	def create
		# @user = User.find(params[:user_id])
		@book = Book.find(params[:book_id])
		# @user.update_attribute(:number_of_borrowed_books, @user.number_of_borrowed_books+1)
		# @book.update_attribute(:availability, @book.availability-1)
		@borrowing = Borrowing.create(user_id: params[:user_id],
																	book_id: params[:book_id],
																	number_of_extension: 0,
																	due_date: Time.now + @book.number_of_borrowing_days,
																	verified: true)
		flash[:success] = "Request borrowing sent"
		redirect_to @book
	end

	def update
		borrowing = Borrowing.find(params[:id])
		unless params[:extension_day].empty?
			borrowing.update_attributes(request: params[:extension_day]+" days extension")
			flash[:success] = "Extesion requesst sent"
		else
			flash[:danger] = "No extension day input"
		end
		redirect_to '/'
	end

	def destroy
		# @user = User.find(params[:user_id])
		# @book = Book.find(params[:book_id])
		# @user.update_attribute(:number_of_borrowed_books, @user.number_of_borrowed_books-1)
		# @book.update_attribute(:availability, @book.availability+1)
		Borrowing.find(params[:id]).delete
		redirect_to '/'
	end

end
