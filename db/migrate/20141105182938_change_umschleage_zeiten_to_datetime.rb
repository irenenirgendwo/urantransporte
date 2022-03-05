class ChangeUmschleageZeitenToDatetime < ActiveRecord::Migration[4.2]
  def change
    change_column :umschlaege, :start_datum, :datetime
    change_column :umschlaege, :end_datum, :datetime
  end
end
