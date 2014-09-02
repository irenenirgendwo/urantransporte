class CreateAnlagenSynonyms < ActiveRecord::Migration
  def change
    create_table :anlagen_synonyms do |t|
      t.belongs_to :anlage
      t.string :synonym
      t.timestamps
    end
  end
end
