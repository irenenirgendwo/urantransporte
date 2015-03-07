class RemoveAdresseAndPlzFromAnlagen < ActiveRecord::Migration
  def change
    remove_column :anlagen, :adresse, :string
    remove_column :anlagen, :plz, :string
  end
end
