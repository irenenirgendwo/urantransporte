class CreateAnlagenSynonyms < ActiveRecord::Migration
  def change
    create_table :anlagen_synonyms do |t|
      t.integer :anlagen_id
      t.string :synonym
      t.timestamps
    end
  end
end
