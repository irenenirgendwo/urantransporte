class AddImageToSchiffe < ActiveRecord::Migration
  def change
    add_column :schiffe, :bild_url, :string
    add_column :schiffe, :bild_urheber, :string
  end
end
