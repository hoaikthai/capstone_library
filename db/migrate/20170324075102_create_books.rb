class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :name
      t.string :author
      t.string :genre
      t.integer :pages
      t.string :publisher
      t.date :publication_date
      t.integer :availability

      t.timestamps
    end
  end
end
