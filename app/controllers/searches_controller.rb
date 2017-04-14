class SearchesController < ApplicationController

	def new
	end

	def index
		@searches = Book.search(params[:search]).paginate(page: params[:page])
	end

	def create
		args = Array.new
		condition = "name like ? and author like ? and dewey_code like ? and publisher like ?"
		args << condition
		args << "%"+params[:search][:name]+"%"
		args << "%"+params[:search][:author]+"%"
		args << params[:search][:dewey_code]+"%"
		args << "%"+params[:search][:publisher]+"%"
		@books = Book.advanced_search(args)
		@searches = @books.paginate(page: params[:page])
		if @searches.empty?
			flash[:info] = "No book found"
			redirect_to advanced_search_path
		else
			render '/books/index'
		end
	end

	def advanced_search
		args = Array.new
		condition = "name like ? and author like ? and dewey_code like ? and publisher like ?"
		args << condition
		args << "%"+params[:search][:name]+"%"
		args << "%"+params[:search][:author]+"%"
		args << params[:search][:dewey_code]+"%"
		args << "%"+params[:search][:publisher]+"%"
		@books = Book.advanced_search(args)
		@searches = @books.paginate(page: params[:page])
		if @searches.empty?
			flash[:info] = "No book found"
			redirect_to advanced_search_path
		else
			render '/books/index'
		end
	end

end
