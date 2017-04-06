require 'test_helper'

class BorrowingsControllerTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:archer)
		@book = books(:book_one)
	end

  test "should not let not logged in user borrow books" do
  	assert_no_difference 'Borrowing.count' do
  		post borrowings_path, params: { user_id: @user.id, book_id: @book.id }
  	end
  	assert_redirected_to login_url
  end

end
