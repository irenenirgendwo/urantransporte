class CreateStoffe < ActiveRecord::Migration[4.2]
  def change
    create_table :stoffe do |t|
      t.string :bezeichnung
      t.text :beschreibung
      t.string :un_nummer
      t.string :gefahr_nummer

      t.timestamps
    end
  end
end
