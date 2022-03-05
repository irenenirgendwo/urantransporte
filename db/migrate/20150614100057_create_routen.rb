class CreateRouten < ActiveRecord::Migration[4.2]
  def change
    create_table :routen do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
