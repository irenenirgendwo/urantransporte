class AbschnittDateInDatetime < ActiveRecord::Migration
  def change
    change_column :transportabschnitte, :start_datum, :datetime
    change_column :transportabschnitte, :end_datum, :datetime
  end
end
