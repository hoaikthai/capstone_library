class SearchesController < ApplicationController

	def new
	end

	def create
		args = Array.new
		condition = "name like ? and author like ? and genre like ? and publisher like ?"
		args << condition
		args << "%"+params[:search][:name]+"%"
		args << "%"+params[:search][:author]+"%"
		args << "%"+params[:search][:genre]+"%"
		args << "%"+params[:search][:publisher]+"%"
		@books = Book.search(args)
		@searches = @books.paginate(page: params[:page])
		if @searches.empty?
			flash[:info] = "No book found"
			redirect_to search_path
		else
			render '/books/index'
		end
	end

end
