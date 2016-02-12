class AddSchiffColToAbschnitt < ActiveRecord::Migration
  def change
    add_reference :transportabschnitte, :schiff, index: true, foreign_key: true
  end
end
