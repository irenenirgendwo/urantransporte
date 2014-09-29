class AddKategorieToAnlage < ActiveRecord::Migration
  def change
    add_column :anlagen, :anlagen_kategorie_id, :integer
  end
end
