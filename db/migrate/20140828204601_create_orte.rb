class CreateOrte < ActiveRecord::Migration[4.2]
  def change
    create_table :orte do |t|

      t.timestamps
    end
  end
end
