require 'test_helper'

class ReturnBooksTest < ActionDispatch::IntegrationTest

  def setup
  	@lib_user = users(:michael)
  	@user = users(:archer)
  	@borrowing = borrowings(:borrow_one)
  	@borrowed_book = books(:book_one)
  end

  test "return book" do
  	log_in_as @lib_user
  	get borrowings_path
  	assert_select "input.return-button"
  	assert_difference "Borrowing.count", -1 do
  		delete return_path, params: { id: @borrowing.id }
  	end
  	assert_redirected_to borrowings_path
  	follow_redirect!
  	assert_not flash.empty?
  	assert_select "input.return-button"
  end
end
