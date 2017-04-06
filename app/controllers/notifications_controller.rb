class NotificationsController < ApplicationController
	before_action :logged_in_user

  def index
  	@notifications = current_user.notifications
  	if @notifications
	  	@unread = @notifications.map { |n| n if !n.seen? }.reverse
	  	unless @unread.compact.empty?
	  		@unread.each { |n| n.update_attributes(seen: true) }
	  	end
	  	@read = @notifications.map { |n| n if n.seen? }.reverse
	  end
  end

  private
		def logged_in_user
			unless logged_in?
    		store_location
    		flash[:danger] = "Please log in to continue"
    		redirect_to login_url
    	end
    end

end
