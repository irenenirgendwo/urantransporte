class CreateAnlagenKategorien < ActiveRecord::Migration
  def change
    create_table :anlagen_kategorien do |t|
      t.string :name

      t.timestamps
    end
  end
end
