class CreateAtomanlages < ActiveRecord::Migration
  def change
    create_table :atomanlages do |t|
      t.string :name
      t.text :description
      t.string :ort

      t.timestamps
    end
  end
end
