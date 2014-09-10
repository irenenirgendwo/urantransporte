class CreateBeobachtungen < ActiveRecord::Migration
  def change
    create_table :beobachtungen do |t|
      t.date :start_datum
      t.date :end_datum
      t.string :ort
      t.string :geo_koordinaten
      t.text :beschreibung
      t.belongs_to :transportabschnitt

      t.timestamps
    end
  end
end
