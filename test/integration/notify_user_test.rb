require 'test_helper'

class NotifyUserTest < ActionDispatch::IntegrationTest
  
  def setup
  	@lib_user = users(:michael)
  	@user = users(:archer)
    @owed_user = users(:lana)
  	@borrowed_book = books(:book_one)
  	@book = books(:book_two)
    @not_available_book = books(:book_four)
  	@borrowing = borrowings(:borrow_one)
  end

  test "should notify user when approve" do
  	log_in_as @user
  	post borrowings_path, params: { user_id: @user.id, book_id: @book.id }
  	log_in_as @lib_user
  	get root_path
  	borrowing = @user.borrowings.find_by(user_id: @user.id, book_id: @book.id)
  	assert_difference 'Notification.count' do
  		patch approve_path, params: { id: borrowing.id }
  	end
  	log_in_as @user
  	get root_path
  	assert_not flash.empty?
  	get notifications_path
  	get root_path
  	assert flash.empty?
  end
end
