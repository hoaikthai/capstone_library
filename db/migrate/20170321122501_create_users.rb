class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :role
      t.string :email
      t.date :birthday
      t.string :address

      t.timestamps
    end
  end
end
