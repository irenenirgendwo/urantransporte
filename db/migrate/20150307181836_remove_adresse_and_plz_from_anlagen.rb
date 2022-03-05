class RemoveAdresseAndPlzFromAnlagen < ActiveRecord::Migration[4.2]
  def change
    remove_column :anlagen, :adresse, :string
    remove_column :anlagen, :plz, :string
  end
end
