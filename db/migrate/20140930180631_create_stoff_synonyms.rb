class CreateStoffSynonyms < ActiveRecord::Migration[4.2]
  def change
    create_table :stoff_synonyms do |t|
      t.string :synonym
      t.integer :stoff_id

      t.timestamps
    end
  end
end
