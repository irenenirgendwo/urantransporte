class CreateUmschlagorte < ActiveRecord::Migration
  def change
    create_table :umschlagorte do |t|
      t.string :ortsname

      t.timestamps
    end
  end
end
