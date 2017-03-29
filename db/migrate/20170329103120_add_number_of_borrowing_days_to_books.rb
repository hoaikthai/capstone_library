class AddNumberOfBorrowingDaysToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :number_of_borrowing_days, :integer
  end
end
