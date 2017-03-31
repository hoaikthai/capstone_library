class BorrowingsController < ApplicationController

	def create
		# @user = User.find(params[:user_id])
		@book = Book.find(params[:book_id])
		# @user.update_attribute(:number_of_borrowed_books, @user.number_of_borrowed_books+1)
		# @book.update_attribute(:availability, @book.availability-1)
		@borrowing = Borrowing.create(user_id: params[:user_id],
																	book_id: params[:book_id],
																	number_of_extension: 0,
																	due_date: Time.zone.now + @book.number_of_borrowing_days,
																	verified: true)
		respond_to do |format|
			format.html { redirect_to @book }
			format.js
		end
	end

	def update
		borrowing = Borrowing.find(params[:id])
		borrowing.update_attributes(number_of_extension: borrowing.number_of_extension + 1,
																due_date: borrowing.due_date + params[:borrowing][:due_date].to_i.days)
		respond_to do |format|
			format.html { redirect_to current_book }
			format.js
		end
	end

	def destroy
		# @user = User.find(params[:user_id])
		# @book = Book.find(params[:book_id])
		# @user.update_attribute(:number_of_borrowed_books, @user.number_of_borrowed_books-1)
		# @book.update_attribute(:availability, @book.availability+1)
		Borrowing.find(params[:id]).delete
		respond_to do |format|
			format.html { redirect_to @book }
			format.js
		end
	end

end
