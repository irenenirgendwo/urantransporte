class AddBeobachtungFoto < ActiveRecord::Migration[4.2]
  def change
    add_column :beobachtungen, :foto_path, :string
    add_column :beobachtungen, :foto_recht, :string
    add_column :beobachtungen, :begleitung_beschreibung, :text
  end
end
