class AddDetailsToOrte < ActiveRecord::Migration
  def up
    add_column :orte, :name, :string
    add_column :orte, :plz, :string
    add_column :orte, :lat, :float
    add_column :orte, :lon, :float
    rename_column :anlagen, :ort, :ort_id
    rename_column :transportabschnitte, :start_ort, :start_ort_id
    rename_column :transportabschnitte, :end_ort, :end_ort_id
    rename_column :umschlaege, :ort, :ort_id
    change_column :anlagen, :ort_id, :integer
    change_column :transportabschnitte, :start_ort_id, :integer
    change_column :transportabschnitte, :end_ort_id, :integer
    change_column :umschlaege, :ort_id, :integer
  end

  def down
    change_column :anlagen, :ort_id, :string
    change_column :transportabschnitte, :start_ort_id, :string
    change_column :transportabschnitte, :end_ort_id, :string
    change_column :umschlaege, :ort_id, :string
    rename_column :anlagen, :ort_id, :ort
    rename_column :transportabschnitte, :start_ort_id, :start_ort
    rename_column :transportabschnitte, :end_ort_id, :end_ort
    rename_column :umschlaege, :ort_id, :ort
    remove_column :orte, :name, :string
    remove_column :orte, :plz, :string
    remove_column :orte, :lat, :float
    remove_column :orte, :lon, :float
  end
end
