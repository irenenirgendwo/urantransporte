class CreateTransporte < ActiveRecord::Migration
  def change
    create_table :transporte do |t|
      t.float :menge
      t.string :stoff
      t.string :behaeltertyp
      t.integer :start
      t.integer :ziel

      t.timestamps
    end
  end
end
