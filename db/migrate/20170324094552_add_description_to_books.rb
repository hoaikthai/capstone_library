class AddDescriptionToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :description, :text
  end
end
