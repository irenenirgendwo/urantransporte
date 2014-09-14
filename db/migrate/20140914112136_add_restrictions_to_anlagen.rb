class AddRestrictionsToAnlagen < ActiveRecord::Migration
  def change
    change_column :anlagen, :name, :string, :null => false
    change_column :anlagen_synonyms, :synonym, :string, :null => false
    change_column :transporte, :datum, :date, :null => false
    change_column :transporte, :start_anlage_id, :integer, :null => false
    change_column :transporte, :ziel_anlage_id, :integer, :null => false
    change_column :firmen, :name, :string, :null => false
  end

end
