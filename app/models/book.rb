class Book < ApplicationRecord
	validates :name, presence: true, length: { maximum: 50 }
	validates :author, presence: true, length: { maximum: 50 }
	validates :genre, presence: true, length: { maximum: 50 }
	validates :pages, presence: true
	validates :publisher, presence: true, length: { maximum: 50 }
	validates :publication_date, presence: true
	validates :availability, presence: true
	validates :number_of_borrowing_days, presence: true
	validates :dewey_code, presence: true, numericality: { less_than: 1000 }
	has_many :borrowings, dependent: :destroy

	def self.search(params)
		if params
			@books = Book.where("name like ?", "%#{params}%")
		else
			Book.all
		end
	end

	def self.advanced_search(search)
		@books = Book.where(search)
	end

end
