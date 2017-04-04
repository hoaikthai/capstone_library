module SessionsHelper
	def login user
		session[:user_id] = user.id
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

	def logged_in?
		!current_user.nil?
	end

	def current_user? user
		user == current_user
	end

	def forget user
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def logout
		forget current_user
		session.delete(:user_id)
		@current_user = nil
	end

	def remember user
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def redirect_back_or default
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?
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
