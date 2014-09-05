class CreateTransportabschnitte < ActiveRecord::Migration
  def change
    create_table :transportabschnitte do |t|
      t.belongs_to :transport
      t.belongs_to :firma
      t.timestamps
    end
  end
end
