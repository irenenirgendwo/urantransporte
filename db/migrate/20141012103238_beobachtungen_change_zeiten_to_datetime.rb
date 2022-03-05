class BeobachtungenChangeZeitenToDatetime < ActiveRecord::Migration[4.2]
  def change
    remove_column :beobachtungen, :start_datum, :date
    remove_column :beobachtungen, :end_datum, :date
    change_column :beobachtungen, :ankunft_zeit, :datetime
    change_column :beobachtungen, :abfahrt_zeit, :datetime
  end
end
