class AddReedereiToFirma < ActiveRecord::Migration[4.2]
  def change
    add_column :firmen, :reederei, :boolean
    remove_column :firmen, :adresse, :string
    remove_column :firmen, :plz, :string
    remove_column :firmen, :ort, :string
  end
end