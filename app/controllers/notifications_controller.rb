class NotificationsController < ApplicationController
	before_action :logged_in_user

  def index
  	@notifications = current_user.notifications
  	if @notifications
      @read = @notifications.map { |n| n if n.seen? }.compact
      @read.reverse! unless @read.empty?
	  	@unread = @notifications.map { |n| n if !n.seen? }.compact
      @unread.reverse! unless @unread.empty?
	  	unless @unread.empty?
	  		@unread.each { |n| n.update_attributes(seen: true) }
	  	end
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
