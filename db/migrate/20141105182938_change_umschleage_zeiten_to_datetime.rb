class ChangeUmschleageZeitenToDatetime < ActiveRecord::Migration
  def change
    change_column :umschlaege, :start_datum, :datetime
    change_column :umschlaege, :end_datum, :datetime
  end
end
