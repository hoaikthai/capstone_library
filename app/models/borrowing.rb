class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :number_of_extension, numericality: { less_than: 4, 
  	greater_than_or_equal_to: 0}
end
