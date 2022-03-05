class AddKategorieToAnlage < ActiveRecord::Migration[4.2]
  def change
    add_column :anlagen, :anlagen_kategorie_id, :integer
  end
end
