class CreateAnlagen < ActiveRecord::Migration[4.2]
  def change
    create_table :anlagen do |t|
      t.string :name
      t.string :adresse
      t.string :plz
      t.string :ort
      t.text :beschreibung

      t.timestamps
    end
  end
end
