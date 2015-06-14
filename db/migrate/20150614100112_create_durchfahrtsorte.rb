class CreateDurchfahrtsorte < ActiveRecord::Migration
  def change
    create_table :durchfahrtsorte do |t|
      t.integer :index
      t.integer :ort_id
      t.integer :route_id

      t.timestamps null: false
    end
  end
end
