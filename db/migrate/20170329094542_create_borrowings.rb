class CreateBorrowings < ActiveRecord::Migration[5.0]
  def change
    create_table :borrowings do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.datetime :borrowed_time
      t.datetime :due_date
      t.boolean :verified, default: false
      t.integer :number_of_extension, default: 0

      t.timestamps
    end
    add_index :borrowings, [:user_id, :book_id], unique: true
  end
end
