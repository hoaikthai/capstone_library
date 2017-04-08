class AddDeweyCodeToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :dewey_code, :int
  end
end
