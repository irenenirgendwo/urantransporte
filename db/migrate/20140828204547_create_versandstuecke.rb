class CreateVersandstuecke < ActiveRecord::Migration
  def change
    create_table :versandstuecke do |t|

      t.timestamps
    end
  end
end
