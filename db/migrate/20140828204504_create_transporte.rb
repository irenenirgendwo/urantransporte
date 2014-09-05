class CreateTransporte < ActiveRecord::Migration
  def change
    create_table :transporte do |t|
      t.date :datum

      t.integer :start_anlage_id
      t.integer :ziel_anlage_id

      t.belongs_to :transportgenehmigung

      t.decimal :menge
      t.string :stoff
      t.string :behaeltertyp
      t.integer :anzahl

      t.timestamps
    end
  end
end
