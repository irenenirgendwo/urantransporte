class CreateTransportabschnitte < ActiveRecord::Migration
  def change
    create_table :transportabschnitte do |t|

      t.timestamps
    end
  end
end
