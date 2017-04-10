require 'test_helper'

class BorrowBooksTest < ActionDispatch::IntegrationTest
  def setup
  	@lib_user = users(:michael)
  	@user = users(:archer)
    @owed_user = users(:lana)
    @extend_user = users(:malory)
    @borrow_max_user = users(:malo)
  	@borrowed_book = books(:book_one)
  	@book = books(:book_two)
    @not_available_book = books(:book_four)
  	@borrowing = borrowings(:borrow_one)
    @max_extend_borrowing = borrowings(:borrow_three)
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

  test "cannot borrow books when owed books" do
    log_in_as @owed_user
    get root_path
    assert_not flash.empty?
    assert_no_difference 'Borrowing.count' do
      post borrowings_path, params: { user_id: @owed_user.id, book_id: @book.id }
    end
    follow_redirect!
    assert_select 'input.borrow-button'
    assert_not flash.empty?
    delete logout_path
    follow_redirect!
    assert flash.empty?
  end

  test "cannot borrow not available books" do
    log_in_as @user
    get book_path @not_available_book
    assert_no_difference 'Borrowing.count' do
      post borrowings_path, params: { user_id: @user.id, book_id: @not_available_book.id }
    end
    follow_redirect!
    assert_not flash.empty?
  end

  test "cannot borrow more than 5 books" do
    log_in_as @borrow_max_user
    get book_path @book
    assert_no_difference 'Borrowing.count' do
      post borrowings_path, params: { user_id: @borrow_max_user, book_id: @book.id }
    end
    follow_redirect!
    assert_not flash.empty?
  end

  test "cannot extend more than 3 times" do
    log_in_as @extend_user
    get book_path @book
    old_due_date = @max_extend_borrowing.due_date
    patch borrowing_path(@max_extend_borrowing), params: { extension_day: 3 }
    assert_not flash.empty?
    @max_extend_borrowing.reload
    assert_equal old_due_date, @max_extend_borrowing.due_date
  end

end
