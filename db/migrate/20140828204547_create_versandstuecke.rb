class CreateVersandstuecke < ActiveRecord::Migration[4.2]
  def change
    create_table :versandstuecke do |t|
      t.string :container_nummer
      t.belongs_to :transport
      t.timestamps
    end
  end
end
