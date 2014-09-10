class CreateTransportgenehmigungen < ActiveRecord::Migration
  def change
    create_table :transportgenehmigungen do |t|
      t.string :lfd_nr
      t.string :antragssteller
      t.string :stoff
      t.date :antragsdatum
      t.integer :max_anzahl
      t.boolean :schiene
      t.boolean :strasse
      t.boolean :schiene
      t.boolean :luft
      t.boolean :umschlag
      t.date :erstellungsdatum
      t.date :gueltigkeit
      t.timestamps
    end
  end
end
