class ChangeBeobachtungenOrteToReference < ActiveRecord::Migration
  def change
    add_column :beobachtungen, :ort_id, :integer
    remove_column :beobachtungen, :ort, :string
    remove_column :beobachtungen, :lat, :float
    remove_column :beobachtungen, :lon, :float
  end
end
