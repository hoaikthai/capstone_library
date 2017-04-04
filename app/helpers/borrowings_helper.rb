module BorrowingsHelper

	def current_book
		Book.find_by(id: session[:book_id])
	end

	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				login user
				@current_user = user
			end
		end
	end

	def owed_book?
		user = current_user
		borrowings = user.borrowings
		borrowings.each do |i|
			return true if i.due_date < Time.now
		end
		return false
	end

end
