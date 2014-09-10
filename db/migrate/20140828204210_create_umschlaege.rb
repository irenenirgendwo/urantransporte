class CreateUmschlaege < ActiveRecord::Migration
  def change
    create_table :umschlaege do |t|
      t.string :ort
      t.string :terminal
      t.date :start_datum
      t.date :end_datum
      t.belongs_to :firma
      t.belongs_to :transport
      t.timestamps
    end
  end
end
