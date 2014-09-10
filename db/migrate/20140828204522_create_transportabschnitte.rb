class CreateTransportabschnitte < ActiveRecord::Migration
  def change
    create_table :transportabschnitte do |t|
      t.belongs_to :transport
      t.belongs_to :firma
      t.string :verkehrstraeger
      t.date :start_datum
      t.date :end_datum
      t.string :start_ort
      t.string :end_ort
      t.timestamps
    end
  end
end
