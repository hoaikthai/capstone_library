class BorrowingsController < ApplicationController

	def create
		unless owed_book?
			@book = Book.find(params[:book_id])
			@borrowing = Borrowing.create(user_id: params[:user_id],
																		book_id: params[:book_id])
			flash[:success] = "Request borrowing sent"
		else
			flash[:danger] = "You have books not returned"
		end
		redirect_to @book
	end

	def update
		borrowing = Borrowing.find(params[:id])
		unless params[:extension_day].empty?
			if borrowing.number_of_extension == 3
				flash[:danger] = "You have exceeded the number of extension"
			elsif params[:extension_day] < 14
				borrowing.update_attributes(request: (params[:extension_day].to_s + " day".pluralize(params[:extension_day]) +" extension"))
				flash[:success] = "Extesion requesst sent"
			else
				flash[:danger] = "Cannot extend more than 2 weeks"
			end
		else
			flash[:danger] = "No extension day input"
		end
		redirect_to '/'
	end

	def destroy
		Borrowing.find(params[:id]).delete
		redirect_to '/'
	end

	def approve
		borrowing = Borrowing.find_by(id: params[:id])
		@book = Book.find_by(id: borrowing.book_id)
		if !borrowing.verified?
			@user = User.find_by(id: borrowing.user_id)
			@user.update_attributes(number_of_borrowed_books: @user.number_of_borrowed_books+1)
			@book.update_columns(availability: @book.availability-1)
			borrowing.update_attributes(borrowed_time: Time.now,
																	due_date: Time.now + @book.number_of_borrowing_days,
																	verified: true,
																	request: nil)
		else
			borrowing.update_attributes(number_of_extension: borrowing.number_of_extension+1,
																	due_date: borrowing.due_date + borrowing.request.to_i.days,
																	request: nil)
		end
		redirect_to '/'
	end

	def deny
		borrowing = Borrowing.find(params[:id])
		if !borrowing.verified?
			borrowing.delete
		else
			borrowing.update_attributes(request: nil)
		end
		#send msg to user
		redirect_to '/'
	end

end
