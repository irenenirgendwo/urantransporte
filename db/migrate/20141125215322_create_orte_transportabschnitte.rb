class CreateOrteTransportabschnitte < ActiveRecord::Migration[4.2]
  def change
    create_table :orte_transportabschnitte do |t|
      t.belongs_to :ort
      t.belongs_to :transportabschnitt
    end
  end
end
