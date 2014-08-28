class CreateOrte < ActiveRecord::Migration
  def change
    create_table :orte do |t|

      t.timestamps
    end
  end
end
