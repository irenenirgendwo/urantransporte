class CreateFirmen < ActiveRecord::Migration
  def change
    create_table :firmen do |t|
      t.string :name
      t.string :adresse
      t.string :plz
      t.string :ort
      t.text :beschreibung
      t.string :typ # soll sein: Spedition, Reederei, Umschlag, Anlagenbetreiber*in
      t.timestamps
    end
  end
end
