require 'test_helper'

class BorrowBooksTest < ActionDispatch::IntegrationTest
  def setup
  	@lib_user = users(:michael)
  	@user = users(:archer)
  	@borrowed_book = books(:book_one)
  	@book = books(:book_two)
  	@borrowing = borrowings(:borrow_one)
  end

  test "request borrowing" do
  	log_in_as @user
  	get book_path @book
  	assert_template 'books/show'
  	assert_select "form.new_borrowing"
  	assert_difference 'Borrowing.count', 1 do
  		post borrowings_path, params: { user_id: @user.id, book_id: @book.id }
  	end
  	assert_not flash.empty?
  	assert_redirected_to @book
  	follow_redirect!
  	assert_template 'books/show'
  	assert_select 'form.edit_borrowing'
  	assert_select 'form input.cancel-button'
  	get root_path
  	assert_select 'form input.cancel-button'
  	log_in_as @lib_user
  	get root_path
  	assert_select 'input.approve-button'
  	assert_select 'input.deny-button'
  end

  test "approve request borrow" do
  	log_in_as @user
    post borrowings_path, params: { user_id: @user.id, book_id: @book.id }
  	log_in_as @lib_user
  	get root_path
  	borrowing = @user.borrowings.find_by(user_id: @user.id, book_id: @book.id)
  	patch approve_path, params: { id: borrowing.id }
  	follow_redirect!
  	assert_select 'input.approve-button', false
  	assert_select 'input.deny-button', false
  	log_in_as @user
  	get root_path
  	assert_select 'input.extend-button'
  end

  test "deny request borrow" do
  	log_in_as @user
    post borrowings_path, params: { user_id: @user.id, book_id: @book.id }
  	log_in_as @lib_user
  	get root_path
  	assert_select 'input.approve-button'
  	borrowing = @user.borrowings.find_by(user_id: @user.id, book_id: @book.id)
  	assert_difference 'Borrowing.count', -1 do
  		delete deny_path, params: { id: borrowing.id }
  	end
  	assert_select 'input.approve-button', false
  end

  test "extend borrowing" do
  	log_in_as @user
  	old_borrowing = @borrowing.due_date
  	patch borrowing_path(@borrowing), params: { extension_day: 3 }
  	assert_redirected_to root_path
  	follow_redirect!
  	assert_not flash.empty?
  	log_in_as @lib_user
  	get root_path
  	assert_select 'input.approve-button'
  	assert_select 'input.deny-button'
  	#deny
  	assert_no_difference 'Borrowing.count' do
  		delete deny_path, params: { id: @borrowing.id }
  	end

  	log_in_as @user
  	patch borrowing_path(@borrowing), params: { extension_day: 3 }
  	@borrowing.reload
  	log_in_as @lib_user
  	#approve
  	patch approve_path, params: { id: @borrowing.id }
  	@borrowing.reload
  	assert_equal old_borrowing, @borrowing.due_date - 3.days
  end

end
