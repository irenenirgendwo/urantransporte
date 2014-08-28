class CreateBeobachtungen < ActiveRecord::Migration
  def change
    create_table :beobachtungen do |t|
      t.text :beschreibung

      t.timestamps
    end
  end
end
