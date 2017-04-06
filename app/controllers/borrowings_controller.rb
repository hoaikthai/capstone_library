class BorrowingsController < ApplicationController
	before_action :logged_in_user
	before_action :librarian_user, only: [:index]

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
		extension_day = params[:extension_day].to_i
		unless extension_day == 0
			if borrowing.number_of_extension == 3
				flash[:danger] = "You have exceeded the number of extension"
			elsif extension_day < 14
				borrowing.update_attributes(request: (extension_day.to_s + " day".pluralize(extension_day) +" extension").to_s)
				flash[:success] = "Extension request sent"
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
			@user.increment!(:number_of_borrowed_books)
			@book.decrement!(:availability)
			borrowing.update_attributes(borrowed_time: Time.now,
																	due_date: Time.now + @book.number_of_borrowing_days,
																	verified: true,
																	request: nil)
		else
			borrowing.update_attributes(number_of_extension: borrowing.number_of_extension + 1,
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

	def index
		@borrowings = Borrowing.all.map { |b| b if b.verified? }
	end

	def find
		@borrowings = Borrowing.all.map { |b| b if b.verified? && b.book_id == params[:find_borrowing].to_i }
		unless @borrowings.compact.empty?
			flash[:success] = "Borrowing found"
			render :index
		else
			flash[:info] = "No borrowing found"
			@borrowings = Borrowing.all.map { |b| b if b.verified? }
			redirect_to borrowings_path
		end
	end

	def return
		borrowing = Borrowing.find_by(id: params[:id])
		user = User.find_by(id: borrowing.user_id)
		book = Book.find_by(id: borrowing.book_id)
		user.decrement!(:number_of_borrowed_books)
		book.increment!(:availability)
		borrowing.delete
		flash[:success] = "Return successfully"
		redirect_to borrowings_path
	end

	private
		def logged_in_user
			unless logged_in?
    		store_location
    		flash[:danger] = "Please log in to continue"
    		redirect_to login_url
    	end
    end

    def librarian_user
    	unless current_user.role == "librarian"
    		flash[:info] = "You have no right for this"
    		redirect_to root_url
    	end
    end
end
