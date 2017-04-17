class BooksController < ApplicationController
	before_action :valid_user, only: [:new, :edit]

	def index
		@books = Book.search(params[:search]).paginate(page: params[:page], per_page: 10)
    flash.now[:info] = "No books found" if @books.empty?
    respond_to do |format|
      format.html
      format.js
    end
	end

	def show
		@book = Book.find(params[:id])
    @borrowings = @book.borrowings
    session[:book_id] = @book.id
	end

  def new
  	@book = Book.new
  end

  def create
  	@book = Book.new(book_params)
    @book.genre = Dewey.get_genre(@book.dewey_code)
  	if @book.save
  		flash[:info] = "Book added."
  		redirect_to @book
  	else
  		render 'new'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update_attributes(book_params)
      @book.genre = Dewey.get_genre(@book.dewey_code)
      @book.save
  		flash[:success] = "Book updated"
  		redirect_to @book
  	else
  		render 'edit'
  	end
  end

  private

  	def valid_user
  		@user = current_user
  		unless @user.role == "librarian"
  			flash[:danger] = "You have no right for this function."
  			redirect_to root_url
  		end
  	end

  	def book_params
      params.require(:book).permit(:name, :author, :dewey_code, 
      	:publisher, :publication_date, :pages, :availability, :description)
    end

end
