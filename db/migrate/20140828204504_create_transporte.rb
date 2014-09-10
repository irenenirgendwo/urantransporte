class CreateTransporte < ActiveRecord::Migration
  def change
    create_table :transporte do |t|
      t.date :datum

      t.integer :start_anlage_id
      t.integer :ziel_anlage_id

      t.belongs_to :transportgenehmigung
      
      t.decimal :menge # in Tonnen
      t.integer :anzahl
      t.string :stoff
      t.string :un_nummer
      t.string :behaelter

      t.timestamps
    end
  end
end
