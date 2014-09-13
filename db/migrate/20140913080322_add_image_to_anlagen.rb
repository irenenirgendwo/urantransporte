class AddImageToAnlagen < ActiveRecord::Migration
  def change
    add_column :anlagen, :bild_url, :string
    add_column :anlagen, :bild_urheber, :string
  end
end
