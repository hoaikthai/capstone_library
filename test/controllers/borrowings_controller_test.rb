require 'test_helper'

class BorrowingsControllerTest < ActionDispatch::IntegrationTest

  test "should not let not logged in user borrow books" do
  	assert_no_difference 'Borrowing.count' do
  		post borrowings_path, params: { user_id: 2, book_id: 1 }
  	end
  end

end
