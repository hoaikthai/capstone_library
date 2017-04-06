module ApplicationHelper
	def full_title(page_title = '')
    base_title = "Capstone Library"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def owed_book?
		if user = current_user
			borrowings = user.borrowings.map{ |b| b if b.verified? }.compact
			unless borrowings.empty?
				borrowings.each do |i|
					return true if i.due_date < Time.now
				end
				return false
			end
		else
			return false
		end
	end

  def check_notification
  	if current_user
			@notifications = current_user.notifications
			if @notifications.any? { |n| !n.seen? }
				flash[:info] = "You have notifications unread"
			end
			flash[:danger] = "You have books not returned, you cannot borrow more books" if owed_book?
		end
	end

end
