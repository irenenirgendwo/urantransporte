class AddSchiffColToAbschnitt < ActiveRecord::Migration[4.2]
  def change
    add_reference :transportabschnitte, :schiff, index: true, foreign_key: true
  end
end
