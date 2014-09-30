class CreateStoffSynonyms < ActiveRecord::Migration
  def change
    create_table :stoff_synonyms do |t|
      t.string :synonym
      t.integer :stoff_id

      t.timestamps
    end
  end
end
