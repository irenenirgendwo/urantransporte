class CreateRouten < ActiveRecord::Migration
  def change
    create_table :routen do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
