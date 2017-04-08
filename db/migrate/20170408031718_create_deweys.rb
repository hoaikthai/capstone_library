class CreateDeweys < ActiveRecord::Migration[5.0]
  def change
    create_table :deweys do |t|
      t.string :code
      t.string :genre

      t.timestamps
    end
  end
end
