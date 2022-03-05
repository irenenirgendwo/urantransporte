class AddImageToAnlagen < ActiveRecord::Migration[4.2]
  def change
    add_column :anlagen, :bild_url, :string
    add_column :anlagen, :bild_urheber, :string
  end
end
