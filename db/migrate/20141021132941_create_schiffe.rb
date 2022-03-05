class CreateSchiffe < ActiveRecord::Migration[4.2]
  def change
    create_table :schiffe do |t|
      t.string :name
      t.integer :imo
      t.integer :mmsi
      t.string :vesselfinder_url

      t.timestamps
    end
  end
end
